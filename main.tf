provider "aws" {
  region = var.prod_region
  alias  = "prod"

  assume_role {
    role_arn    = var.role_arn    
    external_id = var.external_id
  }
}

provider "aws" {
  region = var.dev_region
  access_key = var.dumb_var
  secret_key = var.dumb_key
}

data "aws_ami" "ubuntu" {
  provider    = aws.prod
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id #"subnet-0966dfeef931d6a8b"
  provider      = aws.prod
  tags = {
    Name = var.tag_name
  }
}




resource "aws_s3_bucket" "b" {
  bucket = "dev-mgi-ty"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev ${aws_instance.web.instance_state}"
  }
}
