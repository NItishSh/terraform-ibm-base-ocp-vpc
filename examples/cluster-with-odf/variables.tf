########################################################################################################################
# Input variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud api token"
  sensitive   = true
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this configuration"
  default     = "ocp"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,14}$", var.prefix))
    error_message = "Prefix must start with a lowercase letter, contain only lowercase letters, digits, and hyphens, and be at most 15 characters."
  }
}

variable "region" {
  type        = string
  description = "IBM Cloud region for cluster deployment (e.g., us-south, eu-de, ca-mon)"
  default     = "ca-mon"
}

variable "cluster_name" {
  type        = string
  description = "Name of the OCP cluster to create"
  default     = "ocp-cluster-with-odf"
}

variable "resource_tags" {
  type        = list(string)
  description = "List of tags to apply to all created resources for identification and cost tracking"
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "List of access management tags to apply to the cluster resources"
  default     = []
}

variable "ocp_entitlement" {
  type        = string
  description = "Value that is applied to the entitlements for OCP cluster provisioning"
  default     = null
}

variable "ocp_version" {
  type        = string
  description = "OpenShift Container Platform version to deploy (format: 4.x)"
  default     = "4.20"
}

variable "operating_system" {
  type        = string
  description = "Operating system for the worker nodes (RHCOS, RHEL_9_64, or REDHAT_8_64)"
  default     = "RHCOS"

  validation {
    condition     = contains(["RHCOS", "RHEL_9_64", "REDHAT_8_64"], var.operating_system)
    error_message = "Operating system must be one of: RHCOS, RHEL_9_64, REDHAT_8_64."
  }
}

variable "machine_type" {
  type        = string
  description = "Machine type (flavor) for the default worker pool nodes (e.g., bx3d.16x80)"
  default     = "bx3d.16x80"
}

variable "odf_addon_version" {
  type        = string
  description = "OpenShift Data Foundation add-on version to install"
  default     = "4.19.0"
}

variable "vpc_zone_count" {
  type        = number
  description = "Number of zones to create VPC resources in"
  default     = 3

  validation {
    condition     = var.vpc_zone_count >= 1 && var.vpc_zone_count <= 3
    error_message = "VPC zone count must be between 1 and 3."
  }
}

