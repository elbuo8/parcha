data "aws_ami" "service" {
  most_recent = true

  filter {
    name   = "tag:Name"
    values = ["${var.environment}-${var.service}-${var.region}"]
  }

  owners = ["self"]
}
