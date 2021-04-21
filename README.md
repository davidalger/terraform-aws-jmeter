# Terraform Module for Deploying JMeter

Deploys and configures JMeter an EC2 instance running CentOS 7.

## Usage

After instance startup, monitor the output of the following for cloud-init completion before running Jmeter:

```
sudo journalctl --no-pager -f | grep cloud-init
```

## License

This work is licensed under the MIT license. See LICENSE file for details.

## Author Information

This project was started in 2019 by [David Alger](https://davidalger.com/).

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |
| aws | ~> 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| authorized\_keys | list of ssh pub key allowed to ssh | `list(any)` | n/a | yes |
| instance\_filter | provide a map of filter to search Instance ID (see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | <pre>list(object({<br>    name   = string<br>    values = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "name": "name",<br>    "values": [<br>      "CentOS 7.9.2009 x86_64"<br>    ]<br>  }<br>]</pre> | no |
| instance\_owner | List of AMI owners to limit search. At least 1 value must be specified. Valid values: an AWS account ID, self (the current account), or an AWS owner alias (e.g. amazon, aws-marketplace, microsoft). Default to centos public account | `list(string)` | <pre>[<br>  "125523088429"<br>]</pre> | no |
| instance\_type | instance type to deploy | `string` | `"c5.2xlarge"` | no |
| instance\_user | service account to run jmeter | `string` | `"jmeter"` | no |
| jmeter\_scenario | a path to a jmeter jmx file tu upload to the ec2 it will be uploaded to /tmp/jmeter.jmx | `string` | `"../jmeter.jmx"` | no |
| jmeter\_version | jmeter version | `string` | `"5.1.1"` | no |
| name | n/a | `string` | n/a | yes |
| security\_groups | Additional security groups to attach to the jmeter instance. | `list(string)` | `[]` | no |
| subnet\_id | n/a | `string` | n/a | yes |
| tags | n/a | `map(string)` | n/a | yes |
| trusted\_ip\_ranges | List of IP ranges to whitelist for ICMP and SSH ingress. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| vpc\_id | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_address | n/a |
| instance\_arn | n/a |
| instance\_id | n/a |
| instance\_name | n/a |
| instance\_user | n/a |

