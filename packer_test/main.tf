provider "aws" {
  region = var.region
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
}

variable "region" {
  description = "Please enter the region where to create the intance"
}

resource "aws_instance" "bootcamp32" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "bootcamp32-instance"
  }
}
