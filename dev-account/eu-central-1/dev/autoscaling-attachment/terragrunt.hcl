# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.

terraform {
  source = "git::git@github.com:lejeunen/containers-infrastructure-modules.git//autoscaling-attachment"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}


# Dependency towards EKS
dependency "eks" {
  config_path = "../eks"
}


# Dependency towards ALB
dependency "alb" {
  config_path = "../alb"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  autoscaling_group_name = element(dependency.eks.outputs.workers_asg_names,0)
  alb_target_group_arn = element(dependency.alb.outputs.target_group_arns,0)
}