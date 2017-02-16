data "aws_acm_certificate" "service" {
  domain   = "${var.domain}"
  statuses = ["ISSUED"]
}
