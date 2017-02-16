variable "environment" {
  default = "staging"
}

variable "region" {
  default = "us-east-1"
}

variable "cidr_range" {
  default = "10.0.0.0/16"
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

provider "aws" {
  region = "${var.region}"
}
