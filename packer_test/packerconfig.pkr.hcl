// Define variables
variable "ami_name" {
  type    = string
  default = "default_name"
}

// Define source for Amazon EBS
source "amazon-ebs" "bootcamp32-ec2" {
  region        = "us-west-2"
  instance_type = "t2.micro"
  ami_name      = var.ami_name
  ssh_username  = "ec2-user"
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "amzn2-ami-hvm-*-x86_64-ebs"
      root-device-type    = "ebs"
    }
    most_recent = true
    owners      = ["amazon"]
  }
}

build {
  name = "bootcamp32-packer"
  sources = [
    "source.amazon-ebs.bootcamp32-ec2"
  ]
}
/*
  provisioner "shell" {
    script = "./ansible.sh"
  }
  provisioner "ansible-local" {
    playbook_file = "./docker.yml"
  }
}
*/
