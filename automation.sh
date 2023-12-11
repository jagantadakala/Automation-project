#!/bin/bash

# Function to check and create inventory.html if not present
check_and_create_inventory() {
    inventory_file="/var/www/html/inventory.html"

    if [ ! -f "$inventory_file" ]; then
        # Create inventory.html with header
        echo -e "Log Type\tDate Created\tType\tSize" > "$inventory_file"
    fi
}

# Function to append entry to inventory.html
append_to_inventory() {
    log_type=$1
    timestamp=$2
    archive_type=$3
    size=$4

    echo -e "${log_type}\t${timestamp}\t${archive_type}\t${size}" >> "/var/www/html/inventory.html"
}

# Step 1: Bookkeeping
check_and_create_inventory

# Step 2: Update package details and package list
sudo apt update -y

# ... (rest of your script)

# Step 6: Create a tar archive of apache2 logs
timestamp=$(date '+%d%m%Y-%H%M%S')
myname="jagan"  # Replace with your name
log_directory="/var/log/apache2/"
tmp_directory="/tmp/"

# Create a tar archive of .log files in /var/log/apache2/
tar -cvf "${tmp_directory}${myname}-httpd-logs-${timestamp}.tar" -C "$log_directory" --exclude='*.zip' --exclude='*.tar' *.log

# Step 7: Update inventory.html with archive information
append_to_inventory "httpd-logs" "$timestamp" "tar" "10K"

# Step 8: Cron Job
cron_file="/etc/cron.d/automation"
script_path="/root/YourRepositoryName/automation.sh"

# Check if cron job is scheduled
if [ ! -f "$cron_file" ]; then
    # Create cron job file
    echo "0 0 * * * root $script_path" > "$cron_file"
fi


