resource "aws_launch_configuration" "web" {
  name_prefix = "web-"

  image_id      = "${data.aws_ami.ubuntu.id}" # Amazon Linux AMI 2018.03.0 (HVM)
  instance_type = "t2.micro"
  #key_name      = var.key_name

  security_groups             = ["${aws_security_group.nodejs.id}"]
  associate_public_ip_address = true

  user_data = data.template_file.node.rendered
  #   <<USER_DATA
  # #!/bin/bash
  # sudo apt update
  # sudo apt install nginx -y
  # echo "$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" > /var/www/html/index.html
  # sudo service nginx start
  #   USER_DATA


  lifecycle {
    create_before_destroy = true
  }
}