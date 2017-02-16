resource "aws_ecr_repository" "store" {
  count = "${length(var.apps)}"
  name  = "${var.environment}-${element(var.apps, count.index)}-store-${var.region}"
}
