variable "name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_groups" {
  description = "Additional security groups to attach to the jmeter instance."
  type        = list(string)
  default     = []
}

variable "instance_type" {
  type        = string
  description = "instance type to deploy"
  default     = "c5.2xlarge"
}

variable "instance_owner" {
  type        = list(string)
  description = "List of AMI owners to limit search. At least 1 value must be specified. Valid values: an AWS account ID, self (the current account), or an AWS owner alias (e.g. amazon, aws-marketplace, microsoft). Default to centos public account"
  default     = ["125523088429"]
}
variable "instance_filter" {
  type = list(object({
    name   = string
    values = list(string)
  }))
  description = "provide a map of filter to search Instance ID (see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)"
  default = [{
    name   = "name"
    values = ["CentOS 7.9.2009 x86_64"]
  }]
}

variable "instance_user" {
  type        = string
  default     = "jmeter"
  description = "service account to run jmeter"
}

variable "jmeter_version" {
  type        = string
  default     = "5.1.1"
  description = "jmeter version"
}

variable "authorized_keys" {
  type        = list(any)
  description = "list of ssh pub key allowed to ssh"
}
variable "jmeter_scenario" {
  type        = string
  default     = "./jmeter.jmx"
  description = "a path to a jmeter jmx file tu upload to the ec2 it will be uploaded to /tmp/jmeter.jmx"
}
variable "trusted_ip_ranges" {
  description = "List of IP ranges to whitelist for ICMP and SSH ingress."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
