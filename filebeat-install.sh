#!/bin/bash

#ps aux | grep -E 'filebeat' | awk '{print $2}' | while read -r l; do kill -9 $l;done
cd /home/ec2-user || { echo "Error: Unable to change to the home directory."; exit 1; }
wget https://devops-tookan.s3.ap-south-1.amazonaws.com/filebeatInstall.zip || { echo "Error: Unable to download Filebeat installation zip."; exit 1; }
unzip filebeatInstall.zip || { echo "Error: Unable to unzip the Filebeat installation zip."; exit 1; }
cd filebeat-8.11.4-linux-x86_64 || { echo "Error: Unable to change to the Filebeat directory."; exit 1; }
#screen -S filebeat-screen || { echo "Error: Unable to create a screen session for Filebeat."; exit 1; }
echo "Provide absolute log path:"
read -r logpath
if [ ! -d "$logpath" ]; then
    echo "Error: The provided log path '$logpath' does not exist."
    exit 1
fi
sed -i "s|<logpath>|$logpath|g" modules.d/system.yml || { echo "Error: Unable to update system.yml with the provided log path."; exit 1; }
sudo ./filebeat -e -c filebeat.yml || { echo "Error: Unable to start Filebeat with the updated configuration."; exit 1; }
exit 0
