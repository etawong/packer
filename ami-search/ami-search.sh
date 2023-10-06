#!/bin/bash

# Function to check AMI existence and perform actions
check_ami_existence() {
  local region="$1"
  local team="$2"
  local env="$3"

  # Dynamically build the AMI name
  local ami_name="bootcamp32-${team}-${env}"

  # Check if the AMI already exists
  local ami_exist=$(aws ec2 describe-images \
    --region "${region}" \
    --filters "Name=name,Values=${ami_name}" \
    --query 'Images[*].ImageId' \
    --output text)

  # If the AMI doesn't exist, build it with Packer
  if [ -z "$ami_exist" ]; then
    echo "AMI does not exist. Building with Packer."
    packer build -var "ami_name=${ami_name}" packerconfig.pkr.hcl
   else
    echo "AMI ${ami_name} already exists."
  fi 

  # Proceed to run Terraform
  cd terraform

  terraform init
  terraform validate
  terraform apply \
    -auto-approve \
    -var "ami_id=${ami_exist}" \
    -var "region=${region}"
}

# Main execution starts here
region="$1"
team="$2"
env="$3"

check_ami_existence "${region}" "${team}" "${env}"
