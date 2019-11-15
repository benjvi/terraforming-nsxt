# General {
variable "nsxt_host" {
  description = "The NSX-T host. Must resolve to a reachable IP address, e.g. `nsxmgr.example.tld`"
  type        = "string"
}

variable "nsxt_username" {
  description = "The NSX-T username, probably `admin`"
  type        = "string"
}

variable "nsxt_password" {
  description = "The NSX-T password"
  type        = "string"
}

variable "allow_unverified_ssl" {
  default = false
  description = "Allow connection to NSX-T manager with self-signed certificates. Set to `true` for POC or development environments"
  type    = "string"
}

variable "env_name" {
  description = "An identifier used to tag resources; examples: `dev`, `EMEA`, `prod`"
  type	      = "string"
}

variable "east_west_transport_zone_name" {
  description = "The name of the Transport Zone that carries internal traffic between the NSX-T components. Also known as the `overlay` transport zone"
  type        = "string"
}

# }

# Logical Routers + Switches {
variable "nsxt_edge_cluster_name" {
  description = "The name of the deployed Edge Cluster, e.g. `edge-cluster-1`"
  type        = "string"
}

variable "nsxt_t0_router_name" {
  default     = "T0-Router"
  description = "The name of the T0 router"
  type        = "string"
}

# }

# External IP Ranges {

variable "pas_external_ip_pool_cidr" {
  description = "The CIDR for the External IP Pool. Must be reachable from clients outside the foundation. Can be RFC1918 addresses (10.x, 172.16-31.x, 192.168.x), e.g. `10.195.74.0/24`"
  type        = "string"
}

variable "pas_external_ip_pool_ranges" {
  description = "The IP Ranges for the External IP Pool. Each PAS Org will draw an IP address from this pool; make sure you have enough, e.g. `[\"10.195.74.128-10.195.74.250\"]`"
  type        = "list"
}

variable "pas_external_ip_pool_gateway" {
  description = "The gateway for the External IP Pool, e.g. `10.195.74.1`"
  type        = "string"
}

variable "nat_gateway_ip" {
  description = "The IP Address of the SNAT rule for egress traffic from the Infra & Deployment subnets; should be in the same subnet as the external IP pool, but not in the range of available IP addresses, e.g. `10.195.74.15`"
  type        = "string"
}

variable "ops_manager_external_ip" {
  description = "The public IP Address of the Operations Manager. The om's DNS (e.g. `om.system.tld`) should resolve to this IP, e.g. `10.195.74.16`"
  type        = "string"
}

variable "nsxt_lb_web_virtual_server_ip_address" {
  description = "The ip address on which the Virtual Server listens for Web (HTTP(S)) traffic, should be in the same subnet as the external IP pool, but not in the range of available IP addresses, e.g. `10.195.74.17`"
  type        = "string"
}

variable "nsxt_lb_tcp_virtual_server_ip_address" {
  description = "The ip address on which the Virtual Server listens for TCP traffic, should be in the same subnet as the external IP pool, but not in the range of available IP addresses, e.g. `10.195.74.18`"
  type        = "string"
}

variable "nsxt_lb_ssh_virtual_server_ip_address" {
  description = "The ip address on which the Virtual Server listens for SSH traffic, should be in the same subnet as the external IP pool, but not in the range of available IP addresses, e.g. `10.195.74.19`"
  type        = "string"
}

variable "pks_external_ip_pool_range" {
  type        = "string"
}

variable "pks_external_ip_pool_cidr" {
  type        = "string"
}

variable "pks_api_external_ip" {
  description = "External IP that will be assigned to PKS API by NAT"
}

# }

# LB Configuration {
variable "nsxt_lb_pas_tcp_virtual_server_ports" {
  description = "The list of port(s) on which the Virtual Server listens for TCP traffic, e.g. `[\"8080\", \"52135\", \"34000-35000\"]`"
  type        = "list"
}

variable "nsxt_lb_size" {
  default     = "SMALL"
  description = "The size of the Load Balancer. Accepted values: SMALL, MEDIUM, or LARGE"
  type        = "string"
}
# }


# Private IP Ranges {

variable "vm_private_networks_cidr" {
  description = "Covers the statically-defined networks, i.e. infra, deployment and services"
  default = "192.168.0.0/16"
}
variable "infra_subnet_cidr" {
  default = "192.168.1.1/24"
}

variable "deployment_subnet_cidr" {
  default = "192.168.2.1/24"
  type = "string"
}

variable "services_subnet_cidr" {
  default = "192.168.3.1/24"
  type = "string"
}

variable "container_ip_block_cidr" {
  default     = "10.12.0.0/14"
  description = "The CIDR of the container IP Block, e.g. `10.12.0.0/14`"
  type        = "string"
}

variable "pks_api_private_ip" {
}

variable "pks_pods_ip_block_name" {
}

variable "pks_pods_ip_block_cidr" {
}

variable "pks_nodes_ip_block_name" {
}

variable "pks_nodes_ip_block_cidr" {
}

# }
