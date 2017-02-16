variable "name" {
  default = "packer"
}

variable "environment" {
  default = "staging"
}

variable "region" {
  default = "us-east-1"
}

provider "aws" {
  region = "${var.region}"
}
