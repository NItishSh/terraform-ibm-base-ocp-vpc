########################################################################################################################
# Outputs
########################################################################################################################

output "cluster_id" {
  description = "ID of the created OCP cluster"
  value       = module.ocp_cluster.cluster_id
}

output "cluster_name" {
  description = "Name of the created OCP cluster"
  value       = module.ocp_cluster.cluster_name
}

output "cluster_crn" {
  description = "CRN of the created OCP cluster"
  value       = module.ocp_cluster.cluster_crn
}

output "ocp_version" {
  description = "OpenShift version of the cluster"
  value       = module.ocp_cluster.ocp_version
}

output "vpc_id" {
  description = "ID of the VPC created for the cluster"
  value       = ibm_is_vpc.vpc.id
}

output "resource_group_id" {
  description = "ID of the resource group used"
  value       = module.resource_group.resource_group_id
}

output "region" {
  description = "IBM Cloud region where the cluster is deployed"
  value       = var.region
}
