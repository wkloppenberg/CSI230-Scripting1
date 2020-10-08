#!/bin/bash

# file sysinfo.sh
# brief Produces an HTML file with system information
# author william.kloppenberg
# project scripting 1
# date 10/5/2020

#constants

TITLE="Demonstration $HOSTNAME"
CURRENT_TIME="$(date +"%x %r %Z")"
TIME_STAMP="Run by $USER on $CURRENT_TIME"

#functions

# brief An error exit function
error_exit()
{
    echo "$1"1>&2
    exit 1
}

# brief Displays system distribution
distribution()
{
    echo "<h2>Distribution</h2>"
    echo "<pre>"
    cat /etc/lsb-release | grep DESCRIPTION | cut -d "=" -f 2
    echo "</pre>"
}

#brief Displays system kernel version
kernel_ver()
{
    echo "<h2>Kernel Version</h2>"
    echo "<pre>"
    uname -mrs
    echo "</pre>"
}

#brief Displays memory in human readable format
memory()
{
    echo "<h2>Memory</h2>"
    echo "<pre>"
    free
    echo "</pre>"
}

#brief Lists disk devices (root required)
disk_devices()
{
    if [ "$(id -u)" = "0" ]; then
        echo "<h2>Disk Devices</h2>"
        echo "<pre>"
        sfdisk -l
        echo "</pre>"
    else
        error_exit "Must Run as Root. "
    fi
}

#brief Shows disk space in human readable format
disk_space()
{
    echo "<h2>Disk Space</h2>"
    echo "<pre>"
    df
    echo "</pre>"
}

#brief Lists UID and GID for all users with shell prompts
users()
{
    echo "<h2>Users</h2>"
    echo "<pre>"
        for i in $(cat /etc/passwd | grep bash | cut -d ":" -f 6 | sort | cut -d "/" -f 3)
        do
            id $i
        done
    echo "</pre>"
}

#brief Displays network information
net_info()
{
    echo "<h2>Network Information</h2>"
    echo "<pre>"
    hostname -I
    echo "</pre>"
}

#brief Displays system uptime
sys_uptime()
{
    echo "<h2>Uptime</h2>"
    echo "<pre>"
    uptime
    echo "</pre>"
}

#brief Displays the bytes used in each user's home directory (root required)
home_space()
{
    if [ "$(id -u)" = "0" ]; then
        echo "<h2>User Home Directory Space</h2>"
        echo "<pre>"
        echo "Bytes   Directory"
            du -s /home/* | sort -nr
        echo "</pre>"
    else
        error_exit "Must Run as Root. "
    fi
}

#main

cat <<- _EOF_
  <html>
  <head>
      <title>$TITLE</title>
  </head>
  <body>
      <h1>$TITLE</h1>
      <p>$TIME_STAMP<p>
      $(distribution)
      $(kernel_ver)
      $(memory)
      $(disk_devices)
      $(disk_space)
      $(users)
      $(net_info)
      $(home_space)
      $(sys_uptime)
  </body>
  </html>
_EOF_

