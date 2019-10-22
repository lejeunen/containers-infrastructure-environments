# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.

terraform {
  source = "git::git@github.com:lejeunen/containers-infrastructure-modules.git//cluster-access?ref=v0.1.2"

}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  app_namespace = "emasphere"
  username = "developer"
  aws_account = "8XXXXXXXX0"
}