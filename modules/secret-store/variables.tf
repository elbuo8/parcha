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

provider "aws" {
  region = "${var.region}"
}
