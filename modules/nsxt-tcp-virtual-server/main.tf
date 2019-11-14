resource "nsxt_lb_http_monitor" "lb_monitor" {
  count = "${lower(var.monitor_type) == "http" ? 1 : 0}"
  description           = "HTTP Active Health Monitor (healthcheck) for traffic."
  display_name          = "${var.monitor_name}"
  monitor_port          = "${var.monitor_port}"
  request_method        = "GET"
  request_url           = "/health"
  request_version       = "HTTP_VERSION_1_1"
  response_status_codes = [200]

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}

resource "nsxt_lb_tcp_monitor" "lb_monitor" {
  count = "${lower(var.monitor_type) == "tcp" ? 1 : 0}"
  description           = "TCP Active Health Monitor (healthcheck) for traffic."
  display_name          = "${var.monitor_name}"
  monitor_port          = "${var.monitor_port}"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}

resource "nsxt_lb_pool" "lb_pool" {
  description              = "The Server Pool of traffic handling VMs"
  display_name             = "${var.pool_name}"
  algorithm                = "ROUND_ROBIN"
  tcp_multiplexing_enabled = false
  active_monitor_id        = "${lower(var.monitor_type) == "http" ? nsxt_lb_http_monitor.lb_monitor.0.id : nsxt_lb_tcp_monitor.lb_monitor.0.id}"

  snat_translation {
    type          = "${var.snat_translation}"
  }

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}


resource "nsxt_lb_tcp_virtual_server" "lb_virtual_server" {
  description                = "The Virtual Server for traffic"
  display_name               = "${var.virtual_server_name}"
  application_profile_id     = "${var.application_profile_id}"
  ip_address                 = "${var.virtual_server_ip_address}"
  ports                      = "${var.virtual_server_ports}"
  pool_id                    = "${nsxt_lb_pool.lb_pool.id}"

  tag {
    scope = "terraform"
    tag   = "${var.env_name}"
  }
}