
output "t1_router_id" {
  value = "${nsxt_logical_tier1_router.t1.id}"
}

output "t1_to_t0_id" {
  value = "${nsxt_logical_router_link_port_on_tier1.t1_to_t0.id}"
}