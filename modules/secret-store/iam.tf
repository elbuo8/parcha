resource "aws_kms_key" "credstash" {
  count       = "${length(var.apps)}"
  description = "${var.environment}-${element(var.apps, count.index)}-credstash-${var.region}"
}

resource "aws_kms_alias" "credstash" {
  count         = "${length(var.apps)}"
  name          = "alias/${var.environment}-${element(var.apps, count.index)}-credstash-${var.region}"
  target_key_id = "${element(aws_kms_key.credstash.*.key_id, count.index)}"
}

resource "aws_dynamodb_table" "credstash" {
  count          = "${length(var.apps)}"
  name           = "${var.environment}-${element(var.apps, count.index)}-credstash-${var.region}"
  read_capacity  = 10
  write_capacity = 10

  hash_key  = "name"
  range_key = "version"

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "version"
    type = "S"
  }
}

resource "aws_iam_policy" "credstash_RO" {
  count = "${length(var.apps)}"
  name  = "${var.environment}-${element(var.apps, count.index)}-credstash-${var.region}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Resource": "${element(aws_kms_key.credstash.*.arn, count.index)}"
    },
    {
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ],
      "Effect": "Allow",
      "Resource": "${element(aws_dynamodb_table.credstash.*.arn, count.index)}"
    }
  ]
}
EOF
}
