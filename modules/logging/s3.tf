resource "aws_s3_bucket" "logging" {
  bucket        = "${var.environment}-${var.name}-logs-${var.region}"
  region        = "${var.region}"
  force_destroy = true

  tags {
    Name        = "${var.environment}-${var.name}-logs-${var.region}"
    environment = "${var.environment}"
  }
}
