variable "environment" {
  default = "staging"
}

variable "region" {
  default = "us-east-1"
}

variable "cidr_range" {
  default = "10.0.0.0/16"
}

variable "enable_dns_support " {
  default = true
}

variable "enable_dns_hostnames" {
  default = false
}

variable "subnet_bits" {
  default = 4
}

variable "total_subnets" {
  default = 16
}

variable "azs" {
  type = "map"

  default = {
    "us-east-1" = "us-east-1a,us-east-1c,us-east-1d,us-east-1e"
  }
}

variable "tenancy" {
  default = "default"
}

variable "key_pair" {}

variable "bastion_zone_id" {}
variable "bastion_dns" {}

variable "bastion_instance_type" {
  default     = "t2.micro"
  description = "Instance type"
}

provider "aws" {
  region = "${var.region}"
}
