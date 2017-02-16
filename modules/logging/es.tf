resource "aws_elasticsearch_domain" "es" {
  domain_name           = "${var.environment}-${var.name}-logs-${var.region}"
  elasticsearch_version = "${var.es_version}"

  advanced_options {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.accountId}:root"
      },
      "Action": [
        "es:*"
      ],
      "Resource": "arn:aws:es:${var.region}:${var.accountId}:domain/${var.environment}-${var.name}-logs-${var.region}/*"
    },
    {
      "Effect": "Allow",
      "Principal": { "AWS": "*" },
      "Action": [
        "es:*"
      ],
      "Resource": "arn:aws:es:${var.region}:${var.accountId}:domain/${var.environment}-${var.name}-logs-${var.region}/*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": ["${var.bastion_ip}"]
        }
      }
    }
  ]
}
CONFIG

  // TODO: ebs_options, cluster_config

  snapshot_options {
    automated_snapshot_start_hour = 23
  }
  tags {
    Domain      = "${var.environment}-${var.name}-logs-${var.region}"
    environment = "${var.environment}"
  }
}
