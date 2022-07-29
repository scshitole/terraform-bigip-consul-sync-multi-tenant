driver "terraform" {
  log = true
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
    }
  }
}
#log_level = "trace"
consul {
  address = "3.8.9.34:8500"
}

terraform_provider "bigip" {
  address  = "3.7.14.84"
  username = "admin"
  password = "Pxxx7Ol"
  port = 8443
}

 task {
  name = "AS3-tenent_AppA"
  description = "BIG-IP example"
  source = "../"
  providers = ["bigip"]
  services = ["appA"]
  variable_files = ["tenant_AppA.tfvars"]
}
 
 task {
  name = "AS3-tenent_AppB"
  description = "BIG-IP example"
  source = "../"
  providers = ["bigip"]
  services = ["appB"]
  variable_files = ["tenant_AppB.tfvars"]
}
