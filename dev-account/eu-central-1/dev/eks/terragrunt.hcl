# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-eks.git?ref=v6.0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# TODO use dependency towards the VPC module
inputs = {

  cluster_name = "eksdev"
  subnets  = ["subnet-0d2c90ad9091f62e0", "subnet-021200ac004976dee"]
  vpc_id = "vpc-0ab8a69a02d1a086a"

  worker_groups = [
    {
      instance_type = "m5.large"
      asg_max_size  = 1
      tags = [{
        key                 = "Env"
        value               = "dev"
        propagate_at_launch = true
      }]
    }
  ]
}