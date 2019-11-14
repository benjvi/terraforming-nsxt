

resource "nsxt_logical_switch" "ls" {
  display_name = "${var.subnet_name}"

  transport_zone_id = "${var.overlay_tz_id}"
  admin_state       = "UP"

  description      = "Logical Switch for the T1 ${var.subnet_name} Router."
  replication_mode = "MTEP"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}

// create switch on the router
resource "nsxt_logical_port" "lp" {
  display_name = "${var.subnet_name}-lp"

  admin_state       = "UP"
  description       = "Logical Port on the Logical Switch for the T1 ${var.subnet_name} Router."
  logical_switch_id = "${nsxt_logical_switch.ls.id}"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}

// connect switch to router; tell router how to route to switch
resource "nsxt_logical_router_downlink_port" "dp" {
  display_name = "${var.subnet_name}-dp"

  description                   = "Downlink port connecting ${var.subnet_name} router to its Logical Switch"
  logical_router_id             = "${nsxt_logical_tier1_router.t1.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.lp.id}"
  ip_address                    = "${var.subnet_cidr}"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}