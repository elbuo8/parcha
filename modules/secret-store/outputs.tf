output "RO_policies" {
  value = ["${aws_iam_policy.credstash_RO.*.arn}"]
}
