#!/bin/bash

LOG_FILE="security_log.txt"
USER_SNAPSHOT="user_snapshot.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$TIMESTAMP] Running Intrusion Monitor..."
echo "[$TIMESTAMP] Running Intrusion Monitor..." >> $LOG_FILE

# --- Check for failed login attempts ---
FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log | tail -n 5)
if [ ! -z "$FAILED_LOGINS" ]; then
    echo "[$TIMESTAMP] ⚠️ Failed login attempts detected:"
    echo "$FAILED_LOGINS"
    echo "[$TIMESTAMP] ⚠️ Failed login attempts detected:" >> $LOG_FILE
    echo "$FAILED_LOGINS" >> $LOG_FILE
fi

# --- Check for new users ---
if [ ! -f $USER_SNAPSHOT ]; then
    cut -d: -f1 /etc/passwd > $USER_SNAPSHOT
    echo "[$TIMESTAMP] First-time user snapshot created."
    echo "[$TIMESTAMP] User snapshot created." >> $LOG_FILE
else
    NEW_USERS=$(comm -13 $USER_SNAPSHOT <(cut -d: -f1 /etc/passwd))
    if [ ! -z "$NEW_USERS" ]; then
        echo "[$TIMESTAMP] ⚠️ New user(s) detected: $NEW_USERS"
        echo "[$TIMESTAMP] ⚠️ New user(s) detected: $NEW_USERS" >> $LOG_FILE
        cut -d: -f1 /etc/passwd > $USER_SNAPSHOT
    fi
fi

# --- Check for root login ---
ROOT_LOGIN=$(who | grep 'root')
if [ ! -z "$ROOT_LOGIN" ]; then
    echo "[$TIMESTAMP] ⚠️ Root user logged in:"
    echo "$ROOT_LOGIN"
    echo "[$TIMESTAMP] ⚠️ Root user logged in:" >> $LOG_FILE
    echo "$ROOT_LOGIN" >> $LOG_FILE
fi

echo "[$TIMESTAMP] Intrusion check completed."
echo "[$TIMESTAMP] Intrusion check completed." >> $LOG_FILE
echo "---------------------------------------" >> $LOG_FILE

