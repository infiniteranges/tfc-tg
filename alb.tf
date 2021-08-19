resource "aws_lb" "test-lb-tf" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.elb_http.id}"]
  subnets = ["${aws_subnet.public1.id}",
  "${aws_subnet.public2.id}"]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "test-lb-tf" {
  load_balancer_arn = aws_lb.test-lb-tf.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_iam_server_certificate.test_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test-lb-tf.arn
  }
}

resource "aws_lb_target_group" "test-lb-tf" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}


######
###########
resource "aws_iam_server_certificate" "test_cert" {
  name_prefix      = "alb-new-cert"
  certificate_body = file("public.pem")
  private_key      = file("private.pem")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "ourapp" {
  name                      = "terraform-asg-deployment-example"
  availability_zones        = ["us-east-1a"]
  cross_zone_load_balancing = true

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = aws_iam_server_certificate.test_cert.arn
  }
}