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
}

resource "aws_key_pair" "vika" {
  key_name   = "vika-key"
  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}

output "instance_public_ip" {
  #finding output instance public ip
  value = aws_instance.example.public_ip
}
#provider "github" {
  # create a Github repository and getting personal token in Github
 # token        = "ab542365312cd9e581eacaa77eba1ea705c692c2"
 # organization = "terraform-learning"

#resource "github_repository" "terraform-learning-repo" {
  #name        = "terraform-learning-repo"
  #description = "My new repo for Terraform learning"