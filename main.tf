# Create a new instance of the latest Ubuntu 18.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region  = var.region
  version = "~> 2.63.0"


}

# variable "key_name" {
#   default = "ty"

# }
#Feching the latest ubuntu ami
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#### Define data template file for mongodb

data "template_file" "mongodb" {
  template = "${file("${path.module}/template_file/mongo_userdata.tpl")}"


}

#### Define data template file for node 

data "template_file" "node" {
  template = "${file("${path.module}/template_file/node_userdata.tpl")}"
  vars = {
    mongo_ip = "${aws_instance.mongodb.private_ip}"
  }
}

resource "aws_instance" "mongodb" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  #key_name               = var.key_name
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = ["${aws_security_group.mongodb.id}"]
  //security_groups = ["${aws_security_group.mongodb.name}"]
  iam_instance_profile = aws_iam_instance_profile.test_profile.id
  user_data            = data.template_file.mongodb.rendered

  tags = {
    Name = "MongoDb Instance"
  }
}



# resource "aws_instance" "node" {
#   ami                    = "${data.aws_ami.ubuntu.id}"
#   instance_type          = "t2.micro"
#   key_name               = var.key_name
#   subnet_id              = aws_subnet.public_subnet.id
#   vpc_security_group_ids = ["${aws_security_group.nodejs.id}"]
#   //security_groups = ["${aws_security_group.nodejs.name}"]
#   iam_instance_profile = aws_iam_instance_profile.test_profile.id
#   user_data            = data.template_file.node.rendered


#   tags = {
#     Name = "Node Instance"
#   }
# }



