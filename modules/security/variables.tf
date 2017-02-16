variable "name" {
  default = "audit-logs"
}

variable "environment" {
  default = "staging"
}

variable "region" {
  default = "us-east-1"
}

variable "accountId" {}

provider "aws" {
  region = "${var.region}"
}
