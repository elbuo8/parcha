resource "aws_s3_bucket" "cloudtrail" {
  bucket = "${var.environment}-${var.name}-cloudtrail-${var.region}"
  region = "${var.region}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.environment}-${var.name}-cloudtrail-${var.region}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.environment}-${var.name}-cloudtrail-${var.region}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY

  tags {
    Name        = "${var.environment}-${var.name}-cloudtrail-${var.region}"
    environment = "${var.environment}"
  }
}
