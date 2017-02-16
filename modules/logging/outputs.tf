output "WO_policies" {
  value = ["${aws_iam_policy.firehose_write.*.arn}"]
}
