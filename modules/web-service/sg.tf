resource "aws_security_group" "service-lb" {
  name        = "${var.environment}-${var.name}-${var.service}-lb-${var.region}"
  description = "ALB SG"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-${var.name}-${var.service}-lb-${var.region}"
    environment = "${var.environment}"
  }
}

resource "aws_security_group" "service-instances" {
  name        = "${var.environment}-${var.name}-${var.service}-${var.region}"
  description = "Service SG"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "${var.port}"
    to_port         = "${var.port}"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.service-lb.id}"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${var.bastion_sg}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-${var.name}-${var.service}-${var.region}"
    environment = "${var.environment}"
  }
}
