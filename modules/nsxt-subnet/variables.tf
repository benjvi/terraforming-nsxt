
variable "env_name" {
  type = "string"
}

variable "t0_router_id" {
  type = "string"
}

variable "overlay_tz_id" {
  type = "string"
}
variable "subnet_name" {
  type = "string"
}

variable "subnet_cidr" {
  type = "string"
}

variable "t1_failover_mode" {
  type = "string"
  default = null
}

variable "t1_edge_cluster_id" {
  type = "string"
  default = null
}

variable "t1_advertise_lb_vip_routes" {
  type = "string"
  default = false
}