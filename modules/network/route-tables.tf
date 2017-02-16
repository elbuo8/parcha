/*
Default RT
*/
resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags {
    Name        = "${var.environment}-default-rt-ignore-me-${var.region}"
    environment = "${var.environment}"
  }
}

/*
Public RT
*/
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  count = "${length(split(",", lookup(var.azs, var.region)))}"

  tags {
    Name        = "${var.environment}-public-rt-${element(split(",", lookup(var.azs, var.region)), count.index)}"
    environment = "${var.environment}"
  }
}

resource "aws_route" "ig" {
  count                  = "${length(split(",", lookup(var.azs, var.region)))}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  gateway_id             = "${aws_internet_gateway.vpc.id}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = "${length(split(",", lookup(var.azs, var.region)))}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

/*
Private RT
*/
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.vpc.id}"

  count = "${length(split(",", lookup(var.azs, var.region)))}"

  tags {
    Name        = "${var.environment}-private-rt-${element(split(",", lookup(var.azs, var.region)), count.index)}"
    environment = "${var.environment}"
  }
}

resource "aws_eip" "nat" {
  count = "${length(split(",", lookup(var.azs, var.region)))}"
  vpc   = true
}

resource "aws_nat_gateway" "nat" {
  count         = "${length(split(",", lookup(var.azs, var.region)))}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_route" "nat" {
  count                  = "${length(split(",", lookup(var.azs, var.region)))}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count          = "${length(split(",", lookup(var.azs, var.region)))}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
