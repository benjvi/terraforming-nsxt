// create a router
resource "nsxt_logical_tier1_router" "t1" {
  display_name = "T1-${var.subnet_name}"

  description     = "${var.subnet_name} Tier 1 Router."

  failover_mode   = "${var.t1_failover_mode}"
  edge_cluster_id = "${var.t1_edge_cluster_id}"

  enable_router_advertisement = true
  advertise_connected_routes  = true
  advertise_lb_vip_routes     = "${var.t1_advertise_lb_vip_routes}"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}

// create a t0 port to attach to
resource "nsxt_logical_router_link_port_on_tier0" "t0_to_t1" {
  display_name = "T0-to-T1-${var.subnet_name}"

  description       = "Link Port on Logical Tier 0 Router for connecting to Tier 1 ${var.subnet_name} Router."
  logical_router_id = "${var.t0_router_id}"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}

// attach the t1 to the t0
resource "nsxt_logical_router_link_port_on_tier1" "t1_to_t0" {
  display_name = "T1-${var.subnet_name}-to-T0"

  description                   = "Link Port on ${var.subnet_name} Tier 1 Router connecting to Logical Tier 0 Router. Provisioned by Terraform."
  logical_router_id             = "${nsxt_logical_tier1_router.t1.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.t0_to_t1.id}"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}