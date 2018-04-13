resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_range}"
  instance_tenancy     = "${var.tenancy}"
  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags {
    Name        = "${var.environment}-vpc-${var.region}"
    environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.environment}-ig-${var.region}"
    environment = "${var.environment}"
  }
}
