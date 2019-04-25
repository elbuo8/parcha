resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  count = "${length(split(",", lookup(var.azs, var.region)))}"

  cidr_block        = "${cidrsubnet(var.cidr_range, var.subnet_bits, count.index)}"
  availability_zone = "${element(split(",", lookup(var.azs, var.region)), count.index)}"

  tags {
    Name        = "${var.environment}-public-subnet-${element(split(",", lookup(var.azs, var.region)), count.index)}"
    environment = "${var.environment}"
    service     = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  count = "${length(split(",", lookup(var.azs, var.region)))}"

  cidr_block        = "${cidrsubnet(var.cidr_range, var.subnet_bits, var.total_subnets/2 + count.index)}"
  availability_zone = "${element(split(",", lookup(var.azs, var.region)), count.index)}"

  tags {
    Name        = "${var.environment}-private-subnet-${element(split(",", lookup(var.azs, var.region)), count.index)}"
    environment = "${var.environment}"
    service     = "private-subnet"
  }
}
