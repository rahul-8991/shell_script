
#!/bin/bash

# ===================== Configuration =====================
THRESHOLD=5                                   # Alert threshold in %
TO="kudikyalarahul8055@example.com"              # Recipient email
FROM="krahul4u.in@gmail.com"                 # Must match msmtp config
HOSTNAME=$(hostname)
# ========================================================

# Temporary file to collect alert messages
ALERT_FILE=$(mktemp)

# Get disk usage info, skipping header and special filesystems
df -hP | grep -vE '^Filesystem|tmpfs|cdrom' | while read -r line; do
    usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
    mountpoint=$(echo "$line" | awk '{print $6}')

    if [ "$usage" -gt "$THRESHOLD" ]; then
        echo "⚠️  Disk usage on '$mountpoint' is at ${usage}% on host '$HOSTNAME'." >> "$ALERT_FILE"
    fi
done

# If alerts were added, send email
if [ -s "$ALERT_FILE" ]; then
    SUBJECT="[ALERT] Disk Usage Exceeded ${THRESHOLD}% on $HOSTNAME"
    echo -e "To: $TO\nFrom: $FROM\nSubject: $SUBJECT\n\n$(cat "$ALERT_FILE")" | msmtp "$TO"
fi

# Clean up temp file
rm -f "$ALERT_FILE"
