#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

read -p "Enter AWS Access Key ID: " ACCESS_KEY
read -s -p "Enter AWS Secret Access Key: " SECRET_KEY
echo
read -p "Enter AWS Region (e.g., us-east-1): " REGION

aws configure set aws_access_key_id "$ACCESS_KEY"
aws configure set aws_secret_access_key "$SECRET_KEY"
aws configure set region "$REGION"

aws s3 ls
if [ $? -eq 0 ]; then
    echo "$G ✅ AWS CLI is now configured with provided credentials. $N"
else
    echo "$R AWS CLI is not configured properly give correct creds $N"
    exit 1
fi

SOURCE_DIR="/root/DAWS_practice/shell_practice/temp_logs/"
DEST_DIR="s3://rahuldaws-bucket/logs_backup/"
LOG_FILE="/var/log/s3_backup.log"
EXCLUDE_FILE="/tmp/s3-exclude.txt"

if ls "$SOURCE_DIR "/*.log 1> /dev/null 2>&1; then
  echo "✅ .log files found in $SOURCE_DIR"
else
  echo "❌ No .log files found in $SOURCE_DIR"
  exit 1
fi

aws s3 sync "$SOURCE_DIR" "$DEST_DIR" \ --exclude "*" \ --include "*.log" \ --exact-timestamps


if [ $? -eq 0 ]; then
    echo -e "$G copying log files to S3 bucket is success $N"
else
    echo -e "$R Copying log files is failed $N"
fi



