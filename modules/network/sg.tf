/*
Default SG
*/
resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-default-sg-ignore-me-${var.region}"
    environment = "${var.environment}"
  }
}

resource "aws_security_group" "bastion" {
  name        = "${var.environment}-bastion-${var.region}"
  description = "bastion"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    protocol    = "tcp"
    self        = true
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-bastion-${var.region}"
    environment = "${var.environment}"
  }
}

resource "aws_security_group" "internal-ssh" {
  name        = "${var.environment}-internal-ssh-${var.region}"
  description = "internal-ssh"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    protocol        = "tcp"
    self            = true
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${var.environment}-internal-ssh-${var.region}"
    environment = "${var.environment}"
  }
}
