# Data {
data "nsxt_edge_cluster" "edge_cluster" {
  display_name = "${var.nsxt_edge_cluster_name}"
}

data "nsxt_transport_zone" "overlay_tz" {
  display_name = "${var.east_west_transport_zone_name}"
}

data "nsxt_logical_tier0_router" "t0_router" {
  display_name = "${var.nsxt_t0_router_name}"
}
# }

# Subnets config {

module "infra_subnet" {
  source = "./modules/nsxt-subnet"
  env_name = "${var.env_name}"
  subnet_name = "PP-Infrastructure"
  subnet_cidr = "${var.infra_subnet_cidr}"
  overlay_tz_id = "${data.nsxt_transport_zone.overlay_tz.id}"
  t0_router_id = "${data.nsxt_logical_tier0_router.t0_router.id}"
}

module "deployment_subnet" {
  source = "./modules/nsxt-subnet"
  env_name = "${var.env_name}"
  subnet_name = "PAS-Deployment"
  subnet_cidr = "${var.deployment_subnet_cidr}"
  overlay_tz_id = "${data.nsxt_transport_zone.overlay_tz.id}"
  t0_router_id = "${data.nsxt_logical_tier0_router.t0_router.id}"
  // additional configuration for the t1 because we will use LBs in this subnet
  t1_failover_mode = "NON_PREEMPTIVE"
  t1_edge_cluster_id = "${data.nsxt_edge_cluster.edge_cluster.id}"
  t1_advertise_lb_vip_routes = true
}

// TODO: services network

resource "nsxt_ip_block" "pas_container_subnets_ip_block" {
  description  = "Subnets are allocated from this pool to each newly-created Org"
  display_name = "PAS-container-ip-block"
  cidr         = "${var.container_ip_block_cidr}"
}

resource "nsxt_ip_block" "pks_nodes_subnets_ip_block" {
  description  = "pks-nodes-ip-block provisioned by Terraform"
  display_name = "pks-nodes-subnets-ip-block"
  cidr         = "${var.pks_nodes_ip_block_cidr}"
}

resource "nsxt_ip_block" "pks_pods_subnets_ip_block" {
  description  = "pks-pods-ip-block provisioned by Terraform"
  display_name = "pks-pods-subnets-ip-block"
  cidr         = "${var.pks_pods_ip_block_cidr}"
}

# }


# External IP management {
resource "nsxt_ip_pool" "pas_external_ip_pool" {
  description = "IP Pool that provides IPs for each of the NSX-T container networks."
  display_name = "pas-external-ip-pool"

  subnet {
    allocation_ranges = "${var.pas_external_ip_pool_ranges}"
    cidr              = "${var.pas_external_ip_pool_cidr}"
    gateway_ip        = "${var.pas_external_ip_pool_gateway}"
  }

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}

resource "nsxt_ip_pool" "pks_external_ip_pool" {
  description = "pks_external_ip_pool provisioned by Terraform"
  display_name = "pks-external-ip-pool"

  subnet {
    allocation_ranges = ["${var.pks_external_ip_pool_range}"]
    cidr              = "${var.pks_external_ip_pool_cidr}"
  }
}

# }