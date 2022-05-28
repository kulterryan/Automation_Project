#!/bin/bash

# For Upgrad Assignment 1

MYNAME="aryan"
S3_BUCKET="upgrad-aryan"
# Execute APT Update
echo "Executing APT Update"
sudo apt update -y

# Checking Apache2 Installation
INSTALLED=$(dpkg --get-selections apache2 | awk '{print $1}')

# echo $INSTALLED

if [[ $INSTALLED == apache2 ]]; then
    echo "Apache2 is already installed"
else
    echo "Apache2 is not installed"
    sudo apt update -y
    sudo apt install apache2 -y
fi

# Checking Apache System Status

if systemctl status apache2 | grep "active (running)"; then
    echo "Apache2 is running"
else
    # Running Apache2 Service
    echo "Apache2 is not running"
    echo "Starting Apache2 Server"
    sudo systemctl start apache2
    echo "Apache2 is started"
fi

# Timestamp
TIMESTAMP=$(date '+%d%m%Y-%H%M%S')
FILENAME="/tmp/${MYNAME}-httpd-logs-${TIMESTAMP}.tar"

# Creating TAR File
echo "Creating Apache2 Log Archives"

tar -cf ${FILENAME} $(find /var/log/apache2/ -name "*.log") 2>&1

# Copy to S3 Bucket
echo "Copying File to S3 Bucket"
aws s3 cp ${FILENAME} s3://${S3_BUCKET}/${FILENAME}
echo "Uploading Completed..."
echo "Successfully Uploaded ${FILENAME} to S3 Bucket"

# Inventory.HTML
FILEPATH="/var/www/html/"
if [ -e ${FILEPATH}/inventory.html ]; then
    echo "Inventory File Exists"
else
    echo "Inventory File Does Not Exist"
    echo "Creating New Inventory File"
    touch ${FILEPATH}/inventory.html
    echo "<b>Log Type&ensp; &ensp; Date Created &ensp; &ensp; Type &ensp; &ensp; Size</b><br>" >> $FILEPATH
fi

echo "httpd-logs &ensp; &ensp; ${TIMESTAMP} &ensp; &ensp; tar &ensp; &ensp; `du -h ${FILENAME} | awk '{print $1}'`" >> $FILEPATH