resource "aws_iam_role" "builder" {
  name = "${var.environment}-${var.name}-${var.region}"

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

resource "aws_iam_instance_profile" "builder" {
  name = "${var.environment}-${var.name}-${var.region}"

  roles = [
    "${aws_iam_role.builder.name}",
  ]
}

resource "aws_iam_role_policy" "ec2" {
  name = "${var.environment}-${var.name}-ec2-${var.region}"
  role = "${aws_iam_role.builder.name}"

  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
    "Effect": "Allow",
    "Action": ["ec2:Describe*"],
    "Resource": "*",
    "Condition": {
      "StringEquals": {
        "ec2:Region": "${var.region}"
      }
    }
  }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecr" {
  name = "${var.environment}-${var.name}-ecr-${var.region}"
  role = "${aws_iam_role.builder.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage"
    ],
    "Resource": "*"
  }]
}
EOF
}
