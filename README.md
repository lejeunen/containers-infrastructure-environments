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


Check cluster state with _kubectl cluster-info_ and _kubectl get pods -A_



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

Following [best practice](https://github.com/kubernetes/dashboard) , the dashboard is not exposed and the recommended way to access it is to

```
kubectl proxy
aws eks get-token --cluster-name dev01 | jq -r '.status.token'

```

Alternatively, create a service account as described [here](https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca)

The open http://localhost:8001/api/v1/namespaces/kube-system/services/https:dashboard-kubernetes-dashboard:/proxy/#!/login

### Ingress

Order is important

#### Http/Https security groups

Create the 2 security groups that will be used by the ALB for incoming traffic

- security-group-http
- security-group-https

#### nginx-ingress

Create the _nginx-ingress_ itself and a _kubernetes ingress_ for path based mapping

- nginx-ingress

#### ALB

The ALB itself has multiple dependencies :
- security-group-http and https to associate them with the load balancer, for incoming traffic
- vpc for the vpc id and public subnets to use
- eks for the worker security group id, to be able to connect to the workers
- nginx-ingress for the node port to use 

#### Autoscaling attachment

The last step is to associate target group created by the ALB with the workers ASG

- autoscaling-attachment


### App modules

```
cd dev-account/eu-central-1/dev/module1
terragrunt apply 

```

### Test it

Get the url of the ALB with

```
cd alb
terragrunt output dns_name
```

Then try http://dns_name/container1

## Cleaning up

Execute _terragrunt destroy_ on each component, in the inverse order used to create them.

```
cd module1
terragrunt destroy
cd ../autoscaling-attachment
terragrunt destroy
...
```

I sometimes have an issue when destroying the VPC -> delete from the AWS console and _terragrunt refresh_


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

## Things to improve

It would be nice to have the module version (git tag, i.e. v0.1.0) defined once per environment and use it in the source string of each component. I did not manage to do it.