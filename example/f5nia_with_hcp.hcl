## Global Config
log_level   = "DEBUG"
working_dir = "sync-tasks"
port        = 8558

syslog {}

buffer_period {
  enabled = true
  min     = "5s"
  max     = "20s"
}

# Consul Block
 consul {
  address = "localhost:8500"
  service_registration {
    enabled = true
    service_name = "CTS Event AS3 WAF"
    default_check {
      enabled = true
      address = "http://localhost:8558"
   }
}
token = "<token>"
}


# Driver block
driver "terraform-cloud" {
  hostname     = "https://app.terraform.io"
  organization = "SCStest"
  token        = "<token>"
required_providers {
    bigip = {
      source = "F5Networks/bigip"
    }
  }

}

terraform_provider "bigip" {
  address  = "5.2.2.29:8443"
  username = "admin"
  password = "s8!"
}

 task {
  name = "AS3-tenent_AppA"
  description = "BIG-IP example"
  source = "scshitole/consul-sync-multi-tenant/bigip"
  providers = ["bigip"]
  services = ["appA"]
  variable_files = ["tenantA_AppA.tfvars"]
}
 
 task {
  name = "AS3-tenent_AppB"
  description = "BIG-IP example"
  source = "scshitole/consul-sync-multi-tenant/bigip"
  providers = ["bigip"]
  services = ["appB"]
  variable_files = ["tenantB_AppB.tfvars"]
}

