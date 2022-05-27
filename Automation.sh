#!/bin/bash
MYNAME="aryan"
S3_BUCKET="upgrad-aryan"
# Execute APT Update
echo "Executing APT Update"
sudo apt update -y

# Checking Apache2 Installation
INSTALLED=$(dpkg --get-selections apache2 | awk '{print $1}')

#echo $INSTALLED

if [[ $INSTALLED == apache2 ]]; then
    echo "Apache2 is already installed"
else
    echo "Apache2 is not installed"
    sudo apt update -y
    sudo apt install apache2 -y
fi

# Checking Apache System Status
RUNAPACHE=$(service apache2 status | grep "active (running)")
echo $RUNAPACHE
if [[ $RUNAPACHE == "s" ]]; then
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