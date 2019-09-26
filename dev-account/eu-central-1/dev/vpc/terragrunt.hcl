# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v2.15.0"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name          = "vpc-dev"
  cidr = "10.0.0.0/16"
  azs             = ["eu-central-1a", "eu-central-1b"]
  public_subnets  = ["10.0.10.0/24", "10.0.11.0/24"]
  private_subnets = ["10.0.20.0/24", "10.0.21.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true

  vpc_tags = {
    "kubernetes.io/cluster/vpc-dev" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/vpc-dev" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/vpc-dev" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}