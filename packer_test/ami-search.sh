#!/bin/bash

# Prompt user for input
read -p "Enter the Region: " REGION
read -p "Enter the Team: " TEAM
read -p "Enter the Environment: " ENV

# AMI name pattern
AMI_NAME="bootcamp32-$TEAM-$ENV"

# Check if AMI exists
echo "Checking if AMI with name $AMI_NAME exists"
sleep 2
AMI_ID=$(aws ec2 describe-images \
          --region $REGION \
          --filters "Name=name,Values=$AMI_NAME" \
          --query 'Images[0].ImageId' \
          --output text)

if [ "$AMI_ID" != "None" ]; then
  echo "AMI exists. Running Terraform..."
  sleep 2
  #sed -i "s/ami_id_value/$AMI_ID/g" terraform.tfvars
  echo "ami_id = \"$AMI_ID\"" > terraform.tfvars
else
  echo "AMI does not exist. Running Packer to create AMI..."
  sleep 2
  packer init .
  packer validate .
  packer build -var "ami_name=$AMI_NAME" packerconfig.pkr.hcl
  NEW_AMI_ID=$(aws ec2 describe-images \
              --region $REGION \
              --filters "Name=name,Values=$AMI_NAME" \
              --query 'Images[0].ImageId' \
              --output text)
  #sed -i "s/ami_id_value/$NEW_AMI_ID/g" terraform.tfvars
  echo "ami_id = \"$NEW_AMI_ID\"" > terraform.tfvars
fi

# Run Terraform
terraform init
terraform validate
terraform plan
sleep 3
terraform apply -auto-approve

# Remove the .terraform dir
echo "Creation of resource completed"
sleep 1
echo "Removing .terraform directory"
[ -d .terraform ]; rm -rf .terraform
