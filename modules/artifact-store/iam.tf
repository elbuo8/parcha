resource "aws_iam_policy" "store" {
  count = "${length(var.apps)}"
  name  = "${var.environment}-${element(var.apps, count.index)}-store-${var.region}"

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
    "Resource": "${element(aws_ecr_repository.store.*.arn, count.index)}"
  }]
}
EOF
}
