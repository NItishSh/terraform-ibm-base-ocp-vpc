########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.4.8"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

########################################################################################################################
# VPC + Subnet + Public Gateway
########################################################################################################################

resource "ibm_is_vpc" "vpc" {
  name                      = "${var.prefix}-vpc"
  resource_group            = module.resource_group.resource_group_id
  address_prefix_management = "auto"
  tags                      = var.resource_tags
}

resource "ibm_is_public_gateway" "gateway" {
  for_each       = toset([for i in range(1, var.vpc_zone_count + 1) : tostring(i)])
  name           = "${var.prefix}-gateway-${each.value}"
  vpc            = ibm_is_vpc.vpc.id
  resource_group = module.resource_group.resource_group_id
  zone           = "${var.region}-${each.value}"
  tags           = var.resource_tags
}

resource "ibm_is_subnet" "subnet" {
  for_each                 = toset([for i in range(1, var.vpc_zone_count + 1) : tostring(i)])
  name                     = "${var.prefix}-subnet-${each.value}"
  vpc                      = ibm_is_vpc.vpc.id
  resource_group           = module.resource_group.resource_group_id
  zone                     = "${var.region}-${each.value}"
  total_ipv4_address_count = 256
  public_gateway           = ibm_is_public_gateway.gateway[each.key].id
  tags                     = var.resource_tags
}

##############################################################################
# Local values for OCP cluster module inputs
##############################################################################

locals {
  vpc_subnets = {
    default = [
      for subnet in ibm_is_subnet.subnet :
      {
        id         = subnet.id
        zone       = subnet.zone
        cidr_block = subnet.ipv4_cidr_block
      }
    ]
  }

  worker_pools = [
    {
      subnet_prefix    = "default"
      pool_name        = "default"
      machine_type     = var.machine_type
      operating_system = var.operating_system
      workers_per_zone = 2
    }
  ]

  addons = {
    vpc-block-csi-driver = {
      version = "5.2"
    }
    ibm-storage-operator = {
      version = "1.0"
    }
    openshift-data-foundation = {
      version = var.odf_addon_version
      parameters_json = jsonencode([
        {
          name  = "osdStorageClassName"
          value = "ibmc-vpc-block-metro-10iops-tier"
        },
        {
          name  = "billingType"
          value = "advanced"
        },
        {
          name  = "resourceProfile"
          value = "performance"
        },
        {
          name  = "autoDiscoverDevices"
          value = "false"
        },
        {
          name  = "clusterEncryption"
          value = "false"
        },
        {
          name  = "hpcsEncryption"
          value = "false"
        },
        {
          name  = "ignoreNoobaa"
          value = "false"
        },
        {
          name  = "numOfOsd"
          value = "1"
        },
        {
          name  = "ocsUpgrade"
          value = "false"
        },
        {
          name  = "osdSize"
          value = "512Gi"
        }
      ])
    }
  }
}

##############################################################################
# OCP Cluster with ODF
##############################################################################

module "ocp-cluster" {
  source = "../.."
  # remove the above line and uncomment the below 2 lines to consume the module from the registry
  # source            = "terraform-ibm-modules/base-ocp-vpc/ibm"
  # version           = "X.Y.Z" # Replace "X.Y.Z" with a release version to lock into a specific release
  resource_group_id    = module.resource_group.resource_group_id
  region               = var.region
  tags                 = var.resource_tags
  cluster_name         = var.cluster_name
  vpc_id               = ibm_is_vpc.vpc.id
  vpc_subnets          = local.vpc_subnets
  ocp_version          = var.ocp_version
  worker_pools         = local.worker_pools
  access_tags          = var.access_tags
  ocp_entitlement      = var.ocp_entitlement
  addons               = local.addons
  force_delete_storage = true
  # disable_public_endpoint = true
  # https://github.com/IBM-Cloud/terraform-provider-ibm/issues/6671 - OVN CNI support issue
}
