resource "aws_alb" "service" {
  name            = "${var.environment}-${var.name}-${var.service}-${var.region}"
  internal        = false
  security_groups = ["${aws_security_group.service-lb.id}"]
  subnets         = ["${var.public_subnets}"]

  enable_deletion_protection = true

  access_logs {
    bucket = "${aws_s3_bucket.service.bucket}"
    prefix = "${var.environment}-${var.name}-${var.service}-${var.region}"
  }

  tags {
    Name        = "${var.environment}-${var.name}-${var.service}-${var.region}"
    environment = "${var.environment}"
  }
}

resource "aws_alb_target_group" "service" {
  name     = "${var.environment}-${var.name}-${var.service}-${var.region}"
  port     = "${var.port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  tags {
    Name        = "${var.environment}-${var.name}-${var.service}-${var.region}"
    environment = "${var.environment}"
  }
}

resource "aws_alb_listener" "service" {
  load_balancer_arn = "${aws_alb.service.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${data.aws_acm_certificate.service.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.service.arn}"
    type             = "forward"
  }
}
