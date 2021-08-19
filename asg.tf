resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web.name}-asg"

  min_size         = 2
  desired_capacity = 2
  max_size         = 2

#   health_check_type = "ELB"
#   load_balancers = [
#     "${aws_elb.web_elb.id}"
#   ]

  launch_configuration = "${aws_launch_configuration.web.name}"

  #availability_zones = ["${var.region}a", "${var.region}b"]
  #   availability_zones = ["${var.region}a", "${var.region}b"]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier = [
    "${aws_subnet.public1.id}",
    "${aws_subnet.public2.id}"
  ]
  target_group_arns = ["${aws_lb_target_group.test-lb-tf.arn}"]
  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}