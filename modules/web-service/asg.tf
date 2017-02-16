resource "aws_launch_configuration" "service" {
  name_prefix                 = "${var.environment}-${var.name}-${var.service}-${var.region}"
  image_id                    = "${data.aws_ami.service.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.service.id}"
  security_groups             = ["${aws_security_group.service-instances.id}"]
  associate_public_ip_address = false
  ebs_optimized               = false
  enable_monitoring           = true
  key_name                    = "${var.key_pair}"
  user_data                   = "${data.template_file.service.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "service" {
  name                 = "${aws_launch_configuration.service.name}"
  launch_configuration = "${aws_launch_configuration.service.id}"

  max_size              = "${var.max_size}"
  min_size              = "${var.min_size}"
  wait_for_elb_capacity = "${var.min_size}"

  health_check_grace_period = 900
  wait_for_capacity_timeout = "${var.timeout}"

  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

  health_check_type   = "ELB"
  target_group_arns   = ["${aws_alb_target_group.service.arn}"]
  vpc_zone_identifier = ["${var.private_subnets}"]

  tag {
    key                 = "Name"
    value               = "${var.environment}-${var.name}-${var.service}-${var.region}"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
