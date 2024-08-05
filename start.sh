#!/bin/bash
# based on the script by James Chambers and Marc Tönsing
# by Eziron July 2021
# Minecraft Server startup script

# Check to make sure we aren't running as root
if [[ $(id -u) = 0 ]]; then
    echo "This script is not meant to run as root or sudo. Please run as a normal user with ./start.sh. Exiting..."
    exit 1
fi

# Check if server is already running
ScreenWipe=$(screen -wipe 2>&1)
if screen -list | grep -q "\.minecraft"; then
    echo "Server is already running! Type screen -r minecraft to open the console"
    exit 1
fi

# Flush out memory to disk so we have the maximum available for Java allocation
sudo sh -c "echo 1 > /proc/sys/vm/drop_caches"
sync

# Check if network interfaces are up
NetworkChecks=0
if [ -e '/sbin/route' ]; then
    DefaultRoute=$(/sbin/route -n | awk '$4 == "UG" {print $2}')
else
    DefaultRoute=$(route -n | awk '$4 == "UG" {print $2}')
fi
while [ -z "$DefaultRoute" ]; do
    echo "Network interface not up, will try again in 1 second"
    sleep 1
    if [ -e '/sbin/route' ]; then
        DefaultRoute=$(/sbin/route -n | awk '$4 == "UG" {print $2}')
    else
        DefaultRoute=$(route -n | awk '$4 == "UG" {print $2}')
    fi
    NetworkChecks=$((NetworkChecks + 1))
    if [ $NetworkChecks -gt 20 ]; then
        echo "Waiting for network interface to come up timed out - starting server without network connection ..."
        break
    fi
done

echo "Starting Minecraft server. To view window type screen -r minecraft."
echo "To minimize the window and let the server run in the background, press Ctrl+A then Ctrl+D"

cd ~/minecraft/
# Start the Minecraft server using screen
