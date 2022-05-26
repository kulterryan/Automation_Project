#!/bin/bash
MYNAME="aryan"
# Execute APT Update
echo "Executing APT Update"
#sudo apt update -y

# Checking Apache2 Installation
INSTALLED=$(dpkg --get-selections apache2 | awk '{print $1}')

#echo $INSTALLED

if [[ $INSTALLED == apache2 ]]; then
    echo "Apache2 is already installed"
else
    echo "Apache2 is not installed"
#    sudo apt update -y
#    sudo apt install apache2 -y
fi

# Checking Apache System Status
RUNAPACHE=$(service apache2 status | grep "active (running)")

if [[ $RUNAPACHE == "s" ]]; then
    echo "Apache2 is running"
else
    # Running Apache2 Service
    echo "Apache2 is not running"
    sudo systemctl start apache2
fi

# Timestamp
TIMESTAMP=$(date '+%d%m%Y-%H%M%S')
FILENAME="/tmp/${MYNAME}-httpd-logs-${TIMESTAMP}.tar"

# Creating TAR File
echo "Creating Apache2 Log Archives"

tar -cf $(tar -cf ${FILENAME} $(find /var/log/apache2/ -name "*.log") 2>&1)
