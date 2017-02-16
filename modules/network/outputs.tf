output "id" {
  value = "${aws_vpc.vpc.id}"
}

output "block" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "bastion_sg" {
  value = "${aws_security_group.bastion.id}"
}

output "internal_ssh_sg" {
  value = "${aws_security_group.internal-ssh.id}"
}

output "bastion_ip" {
  value = "${module.bastion.external_ip}"
}
