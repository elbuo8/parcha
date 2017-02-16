variable "name" {
  default = "events"
}

variable "service" {
  default = "api"
}

variable "environment" {
  default = "staging"
}

variable "region" {
  default = "us-east-1"
}

variable "min_size" {
  default = 0
}

variable "max_size" {
  default = 0
}

variable "instance_type" {
  default = "t2.micro"
}

variable "credstash_policy" {}

variable "logging_policy" {}

variable "vpc_id" {}

variable "vpc_range" {}

variable "bastion_sg" {}

variable "port" {
  default = 3000
}

variable "domain" {}

variable "timeout" {
  default = "10m"
}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "awsELBAccountId" {
  type = "map"

  default = {
    "us-east-1" = "127311923021"
  }
}

variable "accountId" {}

variable "key_pair" {}

provider "aws" {
  region = "${var.region}"
}
