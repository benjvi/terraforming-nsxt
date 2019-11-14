
variable "env_name" {
  type = "string"
}

variable "monitor_name" {
  type = "string"
}


variable "monitor_port" {
  type = "string"
}

variable "monitor_type" {
  type = "string"
}

variable "pool_name" {
  type = "string"
}

variable "snat_translation" {
  type = "string"
  // TRANSPARENT or SNAT_AUTO_MAP, can't remember which is the default and why
}

variable "virtual_server_name" {
  type = "string"
}

variable "virtual_server_ip_address" {
  type = "string"
}

variable "virtual_server_ports" {
  type = "list"
}

variable "application_profile_id" {
  type = "string"

}

