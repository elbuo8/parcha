resource "aws_iam_role" "service" {
  name = "${var.environment}-${var.name}-${var.service}-${var.region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "service" {
  name = "${var.environment}-${var.name}-${var.service}-${var.region}"

  roles = [
    "${aws_iam_role.service.name}",
  ]
}

resource "aws_iam_role_policy_attachment" "credstash" {
  role       = "${aws_iam_role.service.name}"
  policy_arn = "${var.credstash_policy}"
}

resource "aws_iam_role_policy_attachment" "logging" {
  role       = "${aws_iam_role.service.name}"
  policy_arn = "${var.logging_policy}"
}
