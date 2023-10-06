packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = var.ami_name
  instance_type = "t2.micro"
  region        = var.region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}


build {
  name = "docker-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
 /*
  provisioner "shell" {
    script = "./ansible.sh"
  }
  provisioner "ansible-local" {
    playbook_file = "./docker.yml"
  }
  */
}

variable "ami_name" {
    type = string
}

variable "region" {
    type = string
}