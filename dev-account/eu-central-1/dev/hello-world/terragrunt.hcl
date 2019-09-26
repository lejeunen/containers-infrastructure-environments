# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::git@github.com:lejeunen/containers-infrastructure-modules.git//hello-world"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name          = "hello-world-dev"
  instance_type = "t3.micro"

  min_size = 1
  max_size = 1

  server_port = 8080
  elb_port    = 80
}