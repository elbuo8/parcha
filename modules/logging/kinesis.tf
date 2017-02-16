resource "aws_kinesis_firehose_delivery_stream" "logging" {
  count       = "${length(var.apps)}"
  name        = "${var.environment}-${element(var.apps, count.index)}-logs-${var.region}"
  destination = "elasticsearch"

  s3_configuration {
    role_arn           = "${aws_iam_role.firehose.arn}"
    bucket_arn         = "${aws_s3_bucket.logging.arn}"
    compression_format = "Snappy"
    kms_key_arn        = "${aws_kms_key.logging.arn}"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "${var.environment}-${var.name}-logs-${var.region}"
      log_stream_name = "${var.environment}-${var.name}-logs-${var.region}"
    }
  }

  elasticsearch_configuration {
    domain_arn     = "${aws_elasticsearch_domain.es.arn}"
    role_arn       = "${aws_iam_role.firehose.arn}"
    s3_backup_mode = "AllDocuments"
    index_name     = "${element(var.apps, count.index)}"
    type_name      = "${var.es_index_type}"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "${var.environment}-${var.name}-logs-${var.region}"
      log_stream_name = "${var.environment}-${var.name}-logs-${var.region}"
    }
  }
}
