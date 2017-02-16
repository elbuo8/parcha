module "bastion" {
  source          = "github.com/segmentio/stack/bastion"
  region          = "${var.region}"
  security_groups = "${aws_security_group.bastion.id},${aws_security_group.internal-ssh.id}"
  vpc_id          = "${aws_vpc.vpc.id}"
  key_name        = "${var.key_pair}"
  subnet_id       = "${element(aws_subnet.public.*.id, 0)}"
  environment     = "${var.environment}"
}
