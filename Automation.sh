#!/bin/bash

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
    echo "Apache2 is not running"
    sudo systemctl start apache2
fi