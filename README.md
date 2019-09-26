# containers-infrastructure-environments
Terragrunt definitions related to [Containers sandbox](https://github.com/lejeunen/containers)

Required : AWS configuration with profile _dev_


To execute with local reference, override the source

```
cd dev-account/eu-central-1/dev/hello-world
terragrunt apply --terragrunt-source ../../../../../containers-infrastructure-modules//hello-world`

Outputs:

asg_name = tf-asg-20190926070830396400000002
asg_security_group_id = sg-09b7388c5f832dbd8
elb_dns_name = hello-world-dev-1612745828.eu-central-1.elb.amazonaws.com
elb_security_group_id = sg-076c571aea4af57cd
url = http://hello-world-dev-1612745828.eu-central-1.elb.amazonaws.com:80

09:18:31 nlejeune hello-world ±|master ✗|→ curl http://hello-world-dev-1612745828.eu-central-1.elb.amazonaws.com:80
Hello, World

```
