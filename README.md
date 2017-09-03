This will build 2 front in RedHat Enterprise servers, a load balancer for them, a RHEL Oracle DB server, a preconfigured Puppet Enterprise server and a preconfigured Jenkins server in Azure.

# Terraform

Install Terraform locally (https://www.terraform.io/downloads.html)
 - Intialize Terraform (terraform init in your github dir)

 Create a local variables file called terraform.tfvars in the github dir and add that file to your gitignore
 terraform.tfvars example:
 #Azure variables
 subscription_id = "your sub id"
 client_id       = your client id"
 client_secret   = "your secret"
 tenant_id       = "your tenant id"



To run Terraform to build environment:
 terraform plan (this will show you what will be built)

 ***You need to import in your networks like so:***
 terraform import azurerm_subnet.endmz /subscriptions/YOUR-subscription_id/resourceGroups/YOUR-NETWORK-resource_group_name/providers/Microsoft.Network/virtualNetworks/YOUR-virtual_network_name/subnets/YOUR-subnet_dmz_name

 Apply the changes to build env in Azure:
 terraform apply


# If you need to find details on Azure account to connect Terraform to:
First install the Azure CLI tools:
https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

Configure Microsoft Azure Provider in Terraform to work with your Azure
1) az login (follow directions and sign in with your Azure account)
  - You will see output look like this below, id is your subscription ID:
  [
  {
    "cloudName": "",
    "id": "",
    "isDefault": true,
    "name": "",
    "state": "Enabled",
    "tenantId": "",
    "user": {
      "name": "",
      "type": "user"
    }
  }
]
2) We can now create the Service Principal, which will have permissions to manage resources in the specified Subscription using the following command:
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
 - output will look like this below:
{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "azure-cli-2017-06-05-10-41-15",
  "name": "http://azure-cli-2017-06-05-10-41-15",
  "password": "0000-0000-0000-0000-000000000000",
  "tenant": "00000000-0000-0000-0000-000000000000"
}

   These values map to the Terraform variables like so:
   appId is the client_id defined above.
   password is the client_secret defined above.
   tenant is the tenant_id defined above.

3) Log into the Azure and test account:
 - az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID
 - az vm list-sizes --location eastus

 ***Be careful using Terraform now to delete resources, it has imported your existing networks and will delete them. Look at your terraform.state file, you can remove the network resource and then delete things.***


# Next Steps
1) We finish  configuring the Puppet Enterprise Server by hitting its IP and following the instructions.
2) We setup our servers and other resources using Puppet to automate servers configuration
3) We finish setting up Jenkins/Gerrit to automate our builds and code review.

At this point you are using Terraform to build our cloud setup, github for source control, a configured Puppet Server for infrastructure as code, Jenkins/Gerrit for continuous integration.
# We have DevOps!
