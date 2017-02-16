resource "aws_cloudtrail" "cloudtrail" {
  name                          = "${var.environment}-${var.name}-cloudtrail-${var.region}"
  s3_bucket_name                = "${aws_s3_bucket.cloudtrail.id}"
  s3_key_prefix                 = "${var.name}"
  include_global_service_events = false
  kms_key_id                    = "${aws_kms_key.cloudtrail.arn}"

  tags {
    Name        = "${var.environment}-${var.name}-cloudtrail${var.region}"
    environment = "${var.environment}"
  }
}
