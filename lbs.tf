
module "web_vs" {
  source = "./modules/nsxt-tcp-virtual-server"
  env_name             = "${var.env_name}"
  monitor_name = "pas-web-monitor"
  monitor_port = 8080
  monitor_type = "http"
  pool_name = "pas-web-pool"
  snat_translation = "SNAT_AUTO_MAP"
  application_profile_id = "${nsxt_lb_fast_tcp_application_profile.pas_lb_tcp_application_profile.id}"
  virtual_server_ip_address = "${var.nsxt_lb_web_virtual_server_ip_address}"
  virtual_server_name = "pas-web-vs"
  virtual_server_ports = ["80", "443"]
}

// delete this if you're not doing tcp routing
module "tcp_vs" {
  source = "./modules/nsxt-tcp-virtual-server"
  env_name             = "${var.env_name}"
  monitor_name = "pas-tcp-monitor"
  monitor_port = "80"
  monitor_type = "http"
  pool_name = "pas-tcp-pool"
  snat_translation = "TRANSPARENT"
  application_profile_id = "${nsxt_lb_fast_tcp_application_profile.pas_lb_tcp_application_profile.id}"
  virtual_server_ip_address = "${var.nsxt_lb_tcp_virtual_server_ip_address}"
  virtual_server_name = "pas-tcp-vs"
  virtual_server_ports = "${var.nsxt_lb_pas_tcp_virtual_server_ports}"
}

module "ssh_vs" {
  source = "./modules/nsxt-tcp-virtual-server"
  env_name             = "${var.env_name}"
  monitor_name = "pas-ssh-monitor"
  monitor_port = "2222"
  monitor_type = "tcp"
  pool_name = "pas-ssh-pool"
  snat_translation = "TRANSPARENT"
  application_profile_id = "${nsxt_lb_fast_tcp_application_profile.pas_lb_tcp_application_profile.id}"
  virtual_server_ip_address = "${var.nsxt_lb_ssh_virtual_server_ip_address}"
  virtual_server_name = "pas-ssh-vs"
  virtual_server_ports = ["2222"]
}

resource "nsxt_lb_fast_tcp_application_profile" "pas_lb_tcp_application_profile" {
  display_name      = "pas-lb-tcp-application-profile"
  close_timeout     = "8"
  idle_timeout      = "1800"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}

# (the) Load Balancer (itself) {
resource "nsxt_lb_service" "pas_lb" {
  description  = "The Load Balancer for handling Web (HTTP(S)), TCP, and SSH traffic."
  display_name = "${var.env_name}-pas-lb"

  enabled            = true
  logical_router_id  = "${module.deployment_subnet.t1_router_id}"
  size               = "${var.nsxt_lb_size}"
  virtual_server_ids = [
    "${module.web_vs.virtual_server_id}",
    "${module.tcp_vs.virtual_server_id}",
    "${module.ssh_vs.virtual_server_id}"
    ]

  depends_on = [
#    "nsxt_logical_router_link_port_on_tier1.t1_infrastructure_to_t0", this doesn't seem necessary
    "module.deployment_subnet.t1_to_t0_id",
  ]

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}
# }
