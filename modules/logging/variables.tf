variable "name" {
  default = "apps"
}

variable "apps" {
  type    = "list"
  default = ["api"]
}

variable "region" {
  default = "us-east-1"
}

variable "environment" {
  default = "staging"
}

variable "bastion_ip" {}

variable "es_version" {
  default = "2.3"
}

variable "es_index_type" {
  default = "logs"
}

variable "accountId" {}

provider "aws" {
  region = "${var.region}"
}
