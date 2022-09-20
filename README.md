# Terraform CTS module for BIG-IP automation

This projects helps to automate the BIG-IP configuration by automatically updating the BIG-Pool members whenever any new servers are deployed. It can also deploy new virtual server and pool configuration on the BIG-IP with AWAF policy configuration on the VIP.

## Assumptions:

- Enable ASM resource provision on BIG-IP after BIG-IP is deployed

- Install the RPM packages for AS3 and Fast templates

- Tested with AS3 RPM 1.36 and Fast template 1.17.0

- You have VPC Peering already done between the HashiCorp Virtual Network and your AWS VPC where the F5 bigip and backend applications are running. 

It uses Consul terraform Sync ( CTS enterprise 0.6.0+ent version), Consul HCP and Terraform Cloud. CTS  is used for Service Discovery and works with Consul HCP and Terraform Cloud. 

### Run the Consul-terraform-Sync

``` 
cat << EOF > f5nia.hcl

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
token = "${consul_acl_token}"
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

EOF 
```
Make sure you also update the tfvars file for your applications accordingly. The task block above sources the module to deploy the FAST template and looks for the applications in the services section in the task block. For example in the above hcl file it will look for ```appA``` and ```appB``` 

```
cat << EOF > tenantA_AppA.tfvars

tenant="tenant_AppA"
app="AppA"
virtualAddress="10.0.0.201"
virtualPort=8080
defpool="appA_pool"
address="3.7.14.8"
username="admin"
password="Pxxeal"
port=8443

EOF

cat << EOF > tenantB_AppB.tfvars

tenant="tenant_AppB"
app="AppB"
virtualAddress="10.0.0.202"
virtualPort=8080
defpool="appB_pool"
address="5.7.14.4"
username="admin"
password="PxxxxayJ"
port=8443

EOF

```

 It uses the module registry https://registry.terraform.io/modules/scshitole/consul-sync-multi-tenant/bigip/latest and sources the module in the hcl file.


To  Run the Consul Terraform Sync binary use the command as shown below, make sure you are login as root or do sudo su before running the command.

```
consul-terraform-sync -config-file=f5nia.hcl

```

If you want to deploy more applications you just need to create a new task in the ```f5nia.hcl``` file and create appropriate ```tfvars``` file.

Example WAF poicy used is as shown below.

```
{
    "policy": {
        "name": "policy-api-arcadia",
        "description": "Arcadia API",
        "template": {
            "name": "POLICY_TEMPLATE_API_SECURITY"
        },
        "enforcementMode": "blocking",
        "server-technologies": [
            {
                "serverTechnologyName": "MySQL"
            },
            {
                "serverTechnologyName": "Unix/Linux"
            },
            {
                "serverTechnologyName": "MongoDB"
            }
        ],
        "signature-settings": {
            "signatureStaging": false
        },
        "policy-builder": {
            "learnOnlyFromNonBotTraffic": false
        }
    }
}

```

