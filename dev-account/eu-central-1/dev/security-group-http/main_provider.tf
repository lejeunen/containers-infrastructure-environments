# See https://gist.github.com/antonbabenko/2ca1225589c7c6d42f476f97d779d4ff
# See https://github.com/gruntwork-io/terragrunt/issues/311

provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {}
}