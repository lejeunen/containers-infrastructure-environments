# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-eks.git?ref=v6.0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# Dependency towards VPC
dependency "vpc" {
  config_path = "../vpc"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

  cluster_name = dependency.vpc.outputs.name
  subnets  = dependency.vpc.outputs.private_subnets
  vpc_id = dependency.vpc.outputs.vpc_id

  worker_groups = [
    {
      instance_type = "m5.xlarge"
      asg_max_size  = 1
      tags = [{
        key                 = "Env"
        value               = "dev"
        propagate_at_launch = true
      }]
    }
  ]
}