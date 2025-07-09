#!/bin/bash

DISK_USAGE=$(df -hT | grep -v Filesystem)
DISK_THRESHOLD=1 # in project it will be 75
MSG=""
# Function to check if running inside AWS EC2
is_ec2() {
  curl -s --connect-timeout 2 http://169.254.169.254/latest/meta-data/ >/dev/null
}

# Determine the IP address
if is_ec2; then
  echo "🟢 Detected EC2 instance"
  IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
else
  echo "🔵 Detected On-Prem or non-EC2 environment"
  IP=$(hostname -I | awk '{print $1}')
fi

echo "🖥️  Local IP: $IP"

while IFS= read line
do
    USAGE=$(echo $line | awk '{print $6F}' | cut -d "%" -f1)
    PARTITION=$(echo $line | awk '{print $7F}')
    if [ $USAGE -ge $DISK_THRESHOLD ]
    then
        MSG+="High Disk Usage on $PARTITION: $USAGE % <br>" #<br> represents HTML new
    fi
done <<< $DISK_USAGE

#echo -e $MSG

sh mail.sh "DevOps Team" "High Disk Usage" "$IP" "$MSG" "kudikyalarahul8055@gmail.com" "ALERT-High Disk Usage"