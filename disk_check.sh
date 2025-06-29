#!/bin/bash

THRESHOLD=5
EMAIL="kudikyalarahul8055@gmail.com"

# Get disk usage, skip header line
df -hP | grep -vE '^Filesystem|tmpfs|cdrom' | while read line; do
    usage=$(echo $line | awk '{print $5}' | tr -d '%')
    mountpoint=$(echo $line | awk '{print $6}')

    if [ "$usage" -gt "$THRESHOLD" ]; then
        echo "Disk usage on $mountpoint is at ${usage}%" | mail -s "Disk Usage Alert on $HOSTNAME" "$EMAIL"
    fi
done
