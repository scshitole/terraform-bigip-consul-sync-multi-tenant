variable "services" {
  description = "Consul services monitored by consul-terraform-sync"
  type = map(
    object({
      id        = string
      name      = string
      address   = string
      port      = number
      status    = string
      meta      = map(string)
      tags      = list(string)
      namespace = string

      node                  = string
      node_id               = string
      node_address          = string
      node_datacenter       = string
      node_tagged_addresses = map(string)
      node_meta             = map(string)
    })
  )
}
variable "address" {
description = "Provide address of BIG-IP"
}
variable "port" {
description = "BIG-IP Management port if its different than 443"
}
variable "username" {
description = "BIG-IP username mostly its admin"
}
variable "password" {
description = "BIG-IP Password"
}

variable "tenant" {
description = "Name of the tenant"
 default = "SCS"
}
variable "app" {

description = " Name of the App"
 default = "Nginx"
}

variable "defpool" {
description = "Name of the Pool"
 default = "nginx_pool"
}

variable "virtualPort" {
  default = 80
}

variable "virtualAddress" {
  default = "10.0.0.200"
}
