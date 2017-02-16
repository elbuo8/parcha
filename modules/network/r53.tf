resource "aws_route53_record" "bastion" {
  zone_id = "${var.bastion_zone_id}"
  name    = "${var.environment}-${var.region}.${var.bastion_dns}"
  type    = "A"
  ttl     = 300
  records = ["${module.bastion.external_ip}"]
}
