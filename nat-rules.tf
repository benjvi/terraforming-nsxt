
// TODO: check if this is really necessary
resource "nsxt_nat_rule" "snat_vm" {
  display_name = "snat-vm"
  action       = "SNAT"

  logical_router_id = "${data.nsxt_logical_tier0_router.t0_router.id}"
  description       = "SNAT Rule for all VMs with exception of sockets coming in through LBs"
  enabled           = true
  logging           = false
  nat_pass          = false

  match_source_network = "${var.vm_private_networks_cidr}"
  translated_network   = "${var.nat_gateway_ip}"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}

locals {
  om_internal_ip = "${cidrhost(var.infra_subnet_cidr, 10)}"
}

// snat for om needs translate to the same IP clients connect to, so it has a separate rule
resource "nsxt_nat_rule" "snat_om" {
  display_name = "snat-om"
  action       = "SNAT"

  logical_router_id = "${data.nsxt_logical_tier0_router.t0_router.id}"
  description       = "SNAT Rule for Operations Manager"
  enabled           = true
  logging           = false
  nat_pass          = false

  match_source_network = "${local.om_internal_ip}"
  translated_network   = "${var.ops_manager_external_ip}"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}

resource "nsxt_nat_rule" "dnat_om" {
  display_name = "dnat-om"
  action       = "DNAT"

  logical_router_id = "${data.nsxt_logical_tier0_router.t0_router.id}"
  description       = "DNAT Rule for Operations Manager"
  enabled           = true
  logging           = false
  nat_pass          = false

  match_destination_network = "${var.ops_manager_external_ip}"
  translated_network        = "${local.om_internal_ip}"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}

resource "nsxt_nat_rule" "PKS" {
  logical_router_id         = "${data.nsxt_logical_tier0_router.t0_router.id}"
  description               = "PKS DNAT rule provisioned by Terraform"
  display_name              = "PKS"
  action                    = "DNAT"
  enabled                   = true
  translated_network        = "${var.pks_api_private_ip}"
  match_destination_network = "${var.pks_public_ip}"
}

// TODO: PKS API vm also needs SNAT in case we keep them

