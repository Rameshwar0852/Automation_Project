#!/bin/bash

#sudo su
####################################################################################################################################
sudo apt update -y
pkg="apache2"
which $pkg > /dev/null 2>&1
if [ $? == 0 ]
then
echo "$pkg IS ALREADY INSTALLED.... "
else
sudo apt install $pkg
fi
#######################################################################################################################################

pkg="awscli"
which $pkg > /dev/null 2>&1
if [ $? == 0 ]
then
echo "$pkg is ALREADY INSTALLED. "
else
sudo apt install $pkg
fi

##########################################################################################################################################

servstat=$(service apache2 status)
if [[ $servstat == *"active (running)"* ]]; then
  echo "WEB SERVER is RUNNING,,,OK "
else
echo "WEB SERVER IS STOPPED ...."
echo "STARTING WEB SERVER -----ok "
sudo systemctl start apache2
fi

########################################################################################################################################

servstat=$(service apache2 status)
if [[ $servstat == *"active (running)"* ]]; then
  echo "WEB SERVER IS RUNNING,,,,OK "
else 
echo "WEBSERVER...IS DISABLED...."
echo "ENABLING/REBOOTING THE SERVER ----ok "
sudo systemctl restart apache2
fi

##############################################################################################################################################
s3_bucket="upgrad-rameshwar"
myname="Rameshwar"
timestamp=$(date '+%d%m%Y-%H%M%S')
sudo tar -cvf ${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/ 
sudo cp -p  ${myname}-httpd-logs-${timestamp}.tar /tmp/
rm *.tar 

sudo apt update
sudo apt install awscli
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

#########################################################################################################

echo "httpd-logs ${timestamp} 

file="/tmp/${myname}-httpd-logs-${timestamp}.tar" 
filesize=$(ls -lh $file | awk '{print  $5}')

echo "httpd-logs ${timestamp} "$filesize" >>  /var/www/html/inventory.html
