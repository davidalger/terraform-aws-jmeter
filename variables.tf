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
  type    = string
  default = "c5.2xlarge"
}

variable "instance_user" {
  type    = string
  default = "jmeter"
}

variable "authorized_keys" {
  type = list(any)
}

variable "trusted_ip_ranges" {
  description = "List of IP ranges to whitelist for ICMP and SSH ingress."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
