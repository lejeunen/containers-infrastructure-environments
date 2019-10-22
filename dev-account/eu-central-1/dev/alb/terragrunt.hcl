# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-alb.git?ref=v4.1.0"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# Dependency towards VPC
dependency "vpc" {
  config_path = "../vpc"
}

# Dependency towards security-group-http
dependency "sg_http" {
  config_path = "../security-group-http"
}

# Dependency towards security-group-https
dependency "sg_https" {
  config_path = "../security-group-https"
}

# Dependency towards EKS
dependency "eks" {
  config_path = "../eks"
}

# Dependency the nginx-ingress
dependency "nginx" {
  config_path = "../nginx-ingress"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  load_balancer_name            = dependency.vpc.outputs.name
  security_groups               = [dependency.sg_http.outputs.this_security_group_id, dependency.sg_https.outputs.this_security_group_id, dependency.eks.outputs.worker_security_group_id]
  logging_enabled               = false
  subnets                       = dependency.vpc.outputs.public_subnets
  tags                          = "${map("containers/env", "dev", "containers/terraform", "true")}"
  vpc_id                        = dependency.vpc.outputs.vpc_id
  https_listeners_count         = 1
  # TODO reference certificate instead of hard coding
  https_listeners               = "${list(map("certificate_arn", "arn:aws:acm:eu-central-1:8XXXXXXX0:certificate/a8e6c504-c4d3-4ee6-9b09-2e2e54a34e6c", "port", 443))}"
  http_tcp_listeners_count      = 1
  http_tcp_listeners            = "${list(map("port", "80", "protocol", "HTTP"))}"
  target_groups_count           = 1
  target_groups                 = "${list(map("name", "application", "backend_protocol", "HTTP", "backend_port", dependency.nginx.outputs.node_port))}"

  # See https://kubernetes.github.io/ingress-nginx/user-guide/default-backend/
  # Note : according to https://github.com/terraform-aws-modules/terraform-aws-alb/pull/81 I should not
  # have to pass all defaults, but I did not get it to work
  target_groups_defaults = {
    cookie_duration = 86400
    deregistration_delay = 300
    health_check_healthy_threshold = 3
    health_check_interval = 10
    health_check_matcher = "200-299"
    health_check_path = "/healthz"    # only this one differs from default values
    health_check_port = "traffic-port"
    health_check_timeout = 5
    health_check_unhealthy_threshold = 3
    stickiness_enabled = false
    target_type = "instance"
    slow_start = 0
  }

  extra_ssl_certs_count         = 0
  extra_ssl_certs               = []
}