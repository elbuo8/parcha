resource "aws_cloudwatch_log_group" "logging" {
  name = "${var.environment}-${var.name}-logs-${var.region}"

  tags {
    name        = "${var.environment}-${var.name}-logs-${var.region}"
    environment = "${var.environment}"
  }
}

resource "aws_cloudwatch_log_stream" "logging" {
  name           = "${var.environment}-${var.name}-logs-${var.region}"
  log_group_name = "${aws_cloudwatch_log_group.logging.name}"
}
