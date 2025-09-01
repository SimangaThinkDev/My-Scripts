# Automated System Updates Cron Job

## Overview
This setup automates system package updates using a cron job that runs every Monday at 6:30 AM. The script performs `apt update` and `apt upgrade` operations and logs the results to a file.

## Files
- **Script**: `/home/wtc/update_script.sh`
- **Log file**: `/home/wtc/update_logs.txt`
- **Cron job**: Root's crontab

## Script Content
```bash
#!/bin/bash

# Create log directory if it doesn't exist
LOG_DIR="/home/wtc"
LOG_FILE="$LOG_DIR/update_logs.txt"

# Create log file if it doesn't exist
touch "$LOG_FILE"

# Update and upgrade
if /usr/bin/apt update && /usr/bin/apt upgrade -y; then
    echo "$(date +'%F %T') - Success" >> "$LOG_FILE"
else
    echo "$(date +'%F %T') - Failure" >> "$LOG_FILE"
fi

## Installation Steps

1. Create the script file:

```bash
sudo nano /home/wtc/update_script.sh
```

2. Paste the script content and save the file.

3. Make the script executable:

```bash
sudo chmod +x /home/wtc/update_script.sh
```

4. Create the log file:

```bash
sudo touch /home/wtc/update_logs.txt
sudo chmod 666 /home/wtc/update_logs.txt
```

5. Add to root's crontab:

```bash
sudo crontab -e
```

6. Add this line (runs every Monday at 6:30 AM):

```bash
30 6 * * 1 /home/wtc/update_script.sh >/dev/null 2>&1
```

Cron Schedule Explanation

- 30 6 * * 1 = Every Monday at 6:30 AM

- Format: minute hour day month weekday

- * = any value

- 1 = Monday (0=Sunday, 1=Monday, ..., 6=Saturday)

## Debugging and Monitoring

Check if cron job is running:

```bash
sudo crontab -l
```

## Monitor cron execution logs:

```bash
# View recent cron activity
sudo grep CRON /var/log/syslog

# Tail cron logs in real-time
sudo tail -f /var/log/syslog | grep CRON
```

## Check if apt processes are running:

```bash
# Check for active apt processes
ps aux | grep apt

# Check for any locked apt processes
ps aux | grep -i lock
```

## Verify script execution:

```bash
# Test script manually
sudo /home/wtc/update_script.sh

# Check log file content
cat /home/wtc/update_logs.txt

# Check log file permissions
ls -la /home/wtc/update_logs.txt
```

## Check apt update history:

```bash
# View recent package updates
grep -i "upgraded\|installed" /var/log/apt/history.log

# View apt log messages
tail -f /var/log/apt/term.log
```

## Common Issues and Solutions

#### 1. "No MTA installed" warning in syslog

Cause: Cron tries to email output but no mail server is installed

Solution: Redirect output to /dev/null in crontab (already handled)

#### 2. Permission denied errors

Solution: Ensure script is executable and log file is writable

```bash
sudo chmod +x /home/wtc/update_script.sh
sudo chmod 666 /home/wtc/update_logs.txt
```

#### 3. Script not executing

Check: Verify cron syntax and that it's in root's crontab

Test: Run script manually first to identify issues

#### 4. Apt lock issues

Check: Ensure no other apt processes are running

```bash
sudo killall apt apt-get  # Only if safe to do so
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
```

## Log File Format
### The log file will contain entries like:

```text
2023-09-04 06:30:01 - Success
2023-09-11 06:30:02 - Failure
```

## Security Considerations

The script runs with root privileges

Automatic upgrades (-y flag) install all available updates without confirmation

Consider reviewing available updates before production deployment

## Modifying Schedule

To change the schedule, edit the cron expression:

Daily at 2 AM: 0 2 * * *

Every 6 hours: 0 */6 * * *

Weekly on Sunday at midnight: 0 0 * * 0

## Support

For issues, check:

Cron logs: 

```bash
sudo grep CRON /var/log/syslog
```

Script permissions and ownership

```bash
Apt process status: ps aux | grep apt
```

Log file content and permissions

## Quick Reference Commands

```bash
# Quick status check
sudo crontab -l && echo "---" && sudo grep CRON /var/log/syslog | tail -5 && echo "---" && ls -la /home/wtc/update_script.sh /home/wtc/update_logs.txt 2>/dev/null || echo "Files not found"
```


