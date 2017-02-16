output "RO_policies" {
  value = ["${aws_iam_policy.store.*.arn}"]
}
