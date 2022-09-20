# Terraform CTS module for BIG-IP automation

This projects helps to automate the BIG-IP configuration by automatically updating the BIG-Pool members whenever any new servers are deployed. It can also deploy new virtual server and pool configuration on the BIG-IP with AWAF policy configuration on the VIP.

## Assumptions:

- Enable ASM resource provision on BIG-IP after BIG-IP is deployed

- Install the RPM packages for AS3 and Fast templates

- Tested with AS3 RPM 1.36 and Fast template 1.17.0

- You have VPC Peering already done between the HashiCorp Virtual Network and your AWS VPC where the F5 bigip and backend applications are running. 

It uses Consul terraform Sync ( CTS enterprise 0.6.0+ent version), Consul HCP and Terraform Cloud. CTS  is used for Service Discovery and works with Consul HCP and Terraform Cloud. 

### Run the Consul-terraform-Sync

Once the infra is deployed it will provide you all the required details as shown

```
F5_Password = "te4l3RLtMc"
consul_root_token = <sensitive>
consul_url = "https://ssome-consul-cluster.consul.xxxxxf6-6078-40ed-99e.aws.hashicorp.cloud"
f5_ui = "https://3.2.2.6:8443"
next_steps = "Hashicups Application will be ready in ~2 minutes. Use 'terraform output consul_root_token' to retrieve the root token."
ssh_tojumpbox = "ssh -i consul-client ubuntu@18.237.4.21"

```

