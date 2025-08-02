#!/bin/bash

# -------- System Health Monitor Script --------
# Checks CPU, RAM, Disk usage and prints alerts

echo "===== System Health Report ====="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo

# -------- CPU USAGE --------
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
echo "CPU Usage: ${cpu_usage}%"

if (( $(echo "$cpu_usage > 80" | bc -l) )); then
    echo "⚠️  Warning: High CPU usage!"
fi

# -------- MEMORY USAGE --------
mem_total=$(free -m | awk '/Mem:/ {print $2}')
mem_used=$(free -m | awk '/Mem:/ {print $3}')
mem_usage=$(awk "BEGIN {printf \"%.2f\", ($mem_used/$mem_total)*100}")
echo "RAM Usage: $mem_usage%"

if (( $(echo "$mem_usage > 80" | bc -l) )); then
    echo "⚠️  Warning: High RAM usage!"
fi

# -------- DISK USAGE --------
disk_usage=$(df / | awk 'END{print $5}' | sed 's/%//')
echo "Disk Usage (root /): ${disk_usage}%"

if [ "$disk_usage" -gt 80 ]; then
    echo "⚠️  Warning: High Disk usage on /"
fi

# -------- SYSTEM UPTIME --------
echo "Uptime: $(uptime -p)"

# -------- TOP PROCESSES --------
echo
echo "Top 5 Memory Consuming Processes:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

echo "================================="
