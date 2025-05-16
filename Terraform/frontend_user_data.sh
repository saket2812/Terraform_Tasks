#!/bin/bash
sudo apt update -y
sudo apt install -y git nodejs npm

# Clone only the frontend part
git clone https://github.com/saket2812/Terraform_Tasks.git /home/ubuntu/Terraform_Tasks
cd /home/ubuntu/Terraform_Tasks/Frontend

# Install node modules
npm install

# Run Express server
nohup node server.js > /home/ubuntu/frontend.log 2>&1 &
