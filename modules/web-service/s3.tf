resource "aws_s3_bucket" "service" {
  bucket = "${var.environment}-${var.name}-${var.service}-${var.region}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.environment}-${var.name}-${var.service}-${var.region}/*",
      "Principal": {
        "AWS": "arn:aws:iam::${lookup(var.awsELBAccountId, var.region)}:root"
      }
    }
  ]
}
EOF
}
