#!/bin/bash

#this stores the numeric user ID into a variable named USERID
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
#PACKAGES=("mysql" "python" "nginx" "httpd")

#-p is used when if the folder is already present it will skip and if folder is not available it will create
mkdir -p $LOGS_FOLDER
#tee is used to sned output to screen and file at same time and -a used to append without overwriting
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

#by default root user id is 0 if not zero it will throw error and exit
if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N" | tee -a $LOG_FILE
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access" | tee -a $LOG_FILE
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){
    if [ $1 -eq 0 ]
    then
        echo -e "Installing $2 is ... $G SUCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "Installing $2 is ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

#below statement is used to loop over the elements in array mentioned
#for package in ${PACKAGES[@]}
#below statement is used to loop over the command line arguments provided $@ means all cmd line arguments
for package in $@
do
    dnf list installed $package &>>$LOG_FILE
    #$? gives exit status of "dnf list installed $package &>>$LOG_FILE" if already installed it will give 0
    if [ $? -ne 0 ]
    then
        echo "$package is not installed... going to install it" | tee -a $LOG_FILE
        dnf install $package -y &>>$LOG_FILE
        VALIDATE $? "$package"
    else
        echo -e "Nothing to do $package... $Y already installed $N" | tee -a $LOG_FILE
    fi
done