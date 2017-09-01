# Terraform

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



 Create a local variables file in the github dir and add wildcard.tfvars to your gitignore
 terraform.tfvars
 #Azure variables
 subscription_id = "your sub id"
 client_id       = your client id"
 client_secret   = "your secret"
 tenant_id       = "your tenant id"


  Install Terraform locally (https://www.terraform.io/downloads.html)
  - Intialize Terraform (terraform init in your github dir)

  Test the Terraform run:
  terraform plan
  Apply the changes:
  terraform apply
