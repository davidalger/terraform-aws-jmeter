variable "name" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "subnet_id" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "c5.2xlarge"
}
