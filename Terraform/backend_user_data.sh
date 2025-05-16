#!/bin/bash
sudo apt update -y
sudo apt install -y git python3-pip

# Clone only the backend part
git clone https://github.com/saket2812/Terraform_Tasks.git /home/ubuntu/Terraform_Tasks
cd /home/ubuntu/Terraform_Tasks/Backend

# Install Python dependencies
pip3 install -r requirements.txt

# Run Flask app in the background
nohup python3 app.py > /home/ubuntu/backend.log 2>&1 &
