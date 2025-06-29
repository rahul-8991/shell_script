#!/bin/bash
#####################
# Author: rahul
# Purpose: This script gives health status of the servers and sends email alert if disk usage > 5%
#######################

set -x            # Enable debug mode
set -e            # Exit if any command fails
set -o pipefail   # Catch errors in piped commands

# === Configuration ===
THRESHOLD=5
TO="kudikyalarahul8055@gmail.com"     # Recipient email
FROM="krahul4u.in@gmail.com"         # Must match msmtp config
HOSTNAME=$(hostname)
ALERT_FILE=$(mktemp)                # Temporary file for alert content
# ======================

# === Disk usage check ===
echo "----- Disk Usage (df -h) -----" >> "$ALERT_FILE"
df -h >> "$ALERT_FILE"

# Check for disk partitions exceeding threshold
df -hP | grep -vE '^Filesystem|tmpfs|cdrom' | while read -r line; do
    usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
    mountpoint=$(echo "$line" | awk '{print $6}')

    if [ "$usage" -gt "$THRESHOLD" ]; then
        echo -e "\n⚠️ ALERT: Disk usage on '$mountpoint' is at ${usage}%!" >> "$ALERT_FILE"
    fi
done

# === Memory status ===
echo -e "\n----- Memory Usage (free -m) -----" >> "$ALERT_FILE"
free -m >> "$ALERT_FILE"

# === CPU core count ===
echo -e "\n----- CPU Cores (nproc) -----" >> "$ALERT_FILE"
nproc >> "$ALERT_FILE"

# === Running Python processes ===
echo -e "\n----- Running Python Processes -----" >> "$ALERT_FILE"
ps -ef | grep [p]ython | awk '{print $1, $2, $8}' >> "$ALERT_FILE"

# === If disk usage exceeded, send mail ===
if grep -q "⚠️ ALERT" "$ALERT_FILE"; then
    SUBJECT="[ALERT] Server Health Check: complete health check on $HOSTNAME"
else
    SUBJECT="[INFO] Server Health Report from $HOSTNAME"
fi

# Send email using msmtp
echo -e "To: $TO\nFrom: $FROM\nSubject: $SUBJECT\n\n$(cat "$ALERT_FILE")" | msmtp "$TO"

# Clean up
rm -f "$ALERT_FILE"
