terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

#
#-we are using aws provider and specific profile name
#
provider "aws" {
  profile = "viktorija"
  region  = "eu-west-1"
  #shared_credentials_file = "C:/Users/viktorija.matjuka/credentials"
}

#
#-we are trying to find latest 04 Ubuntu image 
#
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

  owners = ["099720109477"]
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.image_id
  key_name      = aws_key_pair.vika.key_name
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}

resource "aws_key_pair" "vika" {
  key_name   = "vika-key"
  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}

output "instance_public_ip" {
  #finding output instance public ip
  value = aws_instance.example.public_ip
}
resource "aws_s3_bucket" "buranbucket" {
  bucket = "buranbucket"
  acl = "private"
}
resource "aws_iam_role_policy" "ec2_policy" {
  name = "learning_ec2_policy"
  role = aws_iam_role.buran-role.id
  policy = file("ec2-policy1.json")
}

resource "aws_iam_role" "buran-role" {
  name = "buran-role"
  assume_role_policy = file("assume-role1.json")
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "learning_ec2_profile"
  role = aws_iam_role.buran-role.name
}