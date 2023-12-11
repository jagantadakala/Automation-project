#!/bin/bash

# Step 1: Update package details and package list
sudo apt update -y

# Step 2: Install apache2 if not already installed
if ! dpkg -l | grep -q apache2; then
    sudo apt install apache2 -y
fi

# Step 3: Ensure apache2 service is running
sudo service apache2 status || sudo service apache2 start

# Step 4: Ensure apache2 service is enabled
sudo systemctl enable apache2

# Step 5: Create a tar archive of apache2 logs
timestamp=$(date '+%d%m%Y-%H%M%S')
myname="jagan"
log_directory="/var/log/apache2/"
tmp_directory="/tmp/"

# Create a tar archive of .log files in /var/log/apache2/
tar -cvf "${tmp_directory}${myname}-httpd-logs-${timestamp}.tar" -C "$log_directory" --exclude='*.zip' --exclude='*.tar' *.log

# Step 6: Run AWS CLI command to copy the archive to S3 bucket
s3_bucket="jagan24"  # Replace with your S3 bucket name
aws s3 cp "${tmp_directory}${myname}-httpd-logs-${timestamp}.tar" "s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar"

