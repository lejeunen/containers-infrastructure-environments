# containers-infrastructure-environments
Terragrunt definitions related to [Containers sandbox](https://github.com/lejeunen/containers)

Required : 

1. AWS configuration with profile _dev_

1. [Install Terraform](https://www.terraform.io/intro/getting-started/install.html).

1. [Install Terragrunt](https://github.com/gruntwork-io/terragrunt/blob/master/README.md#install-terragrunt).



## To build the complete stack

### VPC


```
cd dev-account/eu-central-1/dev/vpc
terragrunt apply 

```


### EKS

The vpc and subnet ids are obtained from the VPC module

```
cd dev-account/eu-central-1/dev/eks
terragrunt apply 

```

Update local kube configuration (in ~/.kube), using the generated kubeconfig file. See the _kubeconfig_filename_ output parameter.


Check cluster state with _kubectl cluster-info_ and _kubectl get nodes -A_



### Infra

#### Tiller

Configuration for the tiller service.

```
cd dev-account/eu-central-1/dev/tiller
terragrunt apply 

```

#### Kubernetes dashboard

Deploy the k8s dashboard.

```
cd dev-account/eu-central-1/dev/kubernetes-dashboard
terragrunt apply 

```

### App modules

```
cd dev-account/eu-central-1/dev/module1
terragrunt apply 

```


## To execute with local reference, override the source

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
