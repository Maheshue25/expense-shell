#!/bin/bash

# Script for installing MySQL on a Linux system

USERID=$(id -u) # Get the current user ID
R="\e[31m" # Red color code
G="\e[32m" # Green color code
Y="\e[33m" # Yellow color code
N="\e[0m"  # No color code

LOGS_FOLDER="/var/log/expense-logs" # Define the logs folder path
LOG_FILE=$(echo $0 | cut -d'.' -f1) # Get the script name without extension for logging
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S") # Get the current timestamp
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE.log" # Define the log file name with path

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "${R}Error: $2${N}" # Print error message in red
        echo "$TIMESTAMP - Error: $2" >> $LOG_FILE_NAME # Log the error message with timestamp
        exit 1 # Exit the script with an error code
    else
        echo -e "${G}$2${N}" # Print success message in green
        echo "$TIMESTAMP - Success: $2" >> $LOG_FILE_NAME # Log the success message with timestamp
    fi
}

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "${R}Error: This script must be run as root.${N}" # Print error message in red
        echo "$TIMESTAMP - Error: This script must be run as root." >> $LOG_FILE_NAME # Log the error message with timestamp
        exit 1 # Exit the script with an error code
    fi
}

echo "Script started executing at $TIMESTAMP" >> $LOG_FILE_NAME # Log the start of script execution with timestamp

CHECK_ROOT # Check if the script is run as root

dnf install mysql-server -y >> $LOG_FILE_NAME 2>&1 # Install MySQL server and log the output
VALIDATE $? "MySQL server installation" # Validate the installation

systemctl enable mysqld >> $LOG_FILE_NAME 2>&1 # Enable MySQL service to start on boot and log the output
VALIDATE $? "MySQL service enabled" # Validate the service enablement

systemctl start mysqld >> $LOG_FILE_NAME 2>&1 # Start MySQL service and log the output
VALIDATE $? "MySQL service started" # Validate the service start

mysql_secure_installation --set-root-password ExpenseApp@1 >> $LOG_FILE_NAME 2>&1 # Run the MySQL secure installation script to set the root password and log the output
VALIDATE $? "Setting Root Password" # Validate the secure installation  
