resource "aws_vpc" "vpc" {
  cidr_block       = "${var.cidr_range}"
  instance_tenancy = "${var.tenancy}"

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
