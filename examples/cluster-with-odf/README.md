# OCP VPC cluster with ODF add-on

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=base-ocp-vpc-odf-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-base-ocp-vpc/tree/main/examples/cluster-with-odf"><img src="https://img.shields.io/badge/Deploy%20with IBM%20Cloud%20Schematics-0f62fe?logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics" style="height: 16px; vertical-align: text-bottom;"></a>
<!-- END SCHEMATICS DEPLOY HOOK -->


A simple example that shows how to provision an OCP VPC cluster with the OpenShift Data Foundation (ODF) add-on.

The following resources are provisioned by this example:

- A new resource group, if an existing one is not passed in.
- A VPC with 3 subnets and public gateways enabled.
- An OCP VPC cluster across the 3 zones.
- The ODF add-on configured for the cluster.

<!-- BEGIN SCHEMATICS DEPLOY TIP HOOK -->
:information_source: Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab
<!-- END SCHEMATICS DEPLOY TIP HOOK -->
