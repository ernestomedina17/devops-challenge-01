# devops-challenge-01
This Project creates an EKS cluster with a single node using terraform modules for all the components, the EKS gets deployed into private subnets.

# Reuirements

1. Install aws cli and make it available in your PATH.
2. Install kubectl cli and make it available in your PATH.
3. Setup the following ENV variables, make sure you have enought permissions to create resources in AWS using your credentials.
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_DEFAULT_REGION
- TF_VAR_aws_account_id: The number id of your AWS account.
- TF_VAR_myhome: E.g. ~/home/$username or /Users/$username

# Installation
```
git clone https://github.com/ernestomedina17/devops-challenge-01.git
cd devops-challenge-01/IaC/
terraform init
```

# Configuration
1. Edit the locals.tf and set the name to anything you want.
2. Edit the env.tfvars to suit your project needs.
3. (Optional) Tweak the resources.tf file if you need specifics.
4. Execute:
```
terraform plan -out .tf_plan.hcl -var-file env.tfvars
```

# Deployment
```
terraform apply .tf_plan.hcl
```

# App installation 
1. Install helm cli and make it available in your PATH
2. Execute: 
```
cd k8s
terraform init
terraform plan -out .tf_plan.hcl -var-file env.tfvars
terraform apply .tf_plan.hcl
```

