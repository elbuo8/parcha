resource "aws_kms_key" "logging" {
  description             = "${var.environment}-${var.name}-logs-${var.region}"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "logging" {
  name          = "alias/${var.environment}-${var.name}-logs-${var.region}"
  target_key_id = "${aws_kms_key.logging.key_id}"
}

resource "aws_iam_role" "firehose" {
  name = "${var.environment}-${var.name}-logs-${var.region}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.accountId}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "firehose" {
  name = "${var.environment}-${var.name}-logs-${var.region}"
  role = "${aws_iam_role.firehose.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:PutObject"
            ],
            "Resource": [
                "${aws_s3_bucket.logging.arn}",
                "${aws_s3_bucket.logging.arn}/*"
            ]
        },
        {
           "Effect": "Allow",
           "Action": [
               "kms:Decrypt",
               "kms:GenerateDataKey"
           ],
           "Resource": [
               "${aws_kms_key.logging.arn}"
           ],
           "Condition": {
               "StringEquals": {
                   "kms:ViaService": "s3.${var.region}.amazonaws.com"
               },
               "StringLike": {
                   "kms:EncryptionContext:aws:s3:arn": "${aws_s3_bucket.logging.arn}/*"
               }
           }
        },
        {
           "Effect": "Allow",
           "Action": [
               "es:DescribeElasticsearchDomain",
               "es:DescribeElasticsearchDomains",
               "es:DescribeElasticsearchDomainConfig",
               "es:ESHttpPost",
               "es:ESHttpGet",
               "es:ESHttpPut"
           ],
          "Resource": [
            "${aws_elasticsearch_domain.es.arn}",
            "${aws_elasticsearch_domain.es.arn}/*"
          ]
       },
       {
          "Effect": "Allow",
          "Action": [
              "logs:PutLogEvents"
          ],
          "Resource": [
              "${aws_cloudwatch_log_stream.logging.arn}"
          ]
       }
    ]
}
EOF
}

resource "aws_iam_policy" "firehose_write" {
  count = "${length(var.apps)}"
  name  = "${var.environment}-${element(var.apps, count.index)}-logs-WO-${var.region}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Resource": [
                "${element(aws_kinesis_firehose_delivery_stream.logging.*.arn, count.index)}"
            ]
        }
    ]
}
EOF
}
