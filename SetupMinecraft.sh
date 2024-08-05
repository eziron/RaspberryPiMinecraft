#!/bin/bash

# Script for easy creation and configuration of a Minecraft server with PaperMC on ARM64 by Eziron
# Updated: 04/08/2024

# I have relied on the scripts of:
# James A. Chambers - https://github.com/TheRemote/RaspberryPiMinecraft
# Marc Tönsing - https://github.com/mtoensing/RaspberryPiMinecraft

# Terminal colors
LIME_YELLOW=$(tput setaf 190)
NORMAL=$(tput sgr0)

cd ~

echo -e "$LIME_YELLOW\nInstallation script for Minecraft PaperMC server on Linux ARM64 by Eziron$NORMAL"

echo -e "$LIME_YELLOW\nUpdating packages...$NORMAL"
sudo apt-get update

# Instalación de dependencias
echo -e "$LIME_YELLOW\nInstalling dependencies...$NORMAL"
sudo apt-get install -y sudo screen net-tools curl pigz

if [ -d "minecraft" ]; then
    echo -e "$LIME_YELLOW\nDirectory 'minecraft' already exists!$NORMAL"
    echo "1) Clean and restart all"
    echo "2) Update/upgrade"
    echo "3) Exit"
    read -p "Choose an option: " Option_A

    case $Option_A in
    1 | clean | restart | "clean and restart all")
        echo -e "\nDeleting all files from server (~/minecraft)..."
        sudo rm -rf ~/minecraft/
        clean_install="yes"
        echo "Creating Minecraft server directory (~/minecraft)..."
        mkdir ~/minecraft
        ;;
    2 | update | upgrade | "update/upgrade")
        clean_install="no"
        ;;
    3 | exit | *)
        echo -e "\nExiting the script, no changes have been made"
        exit 1
        ;;
    esac
else
    clean_install="yes"
    echo "Creating Minecraft server directory (~/minecraft)..."
    mkdir minecraft
fi

cd ~/minecraft

echo -e "$LIME_YELLOW\nWhat version do you want to install?$NORMAL"
echo "  1) 1.21"
echo "  2) 1.20.6"
echo "  3) 1.19.4"
echo "  4) 1.18.2"
echo "  5) 1.17.1"
echo "  6) 1.16.5"
echo "  7) 1.15.2"
echo "  8) 1.14.4"
echo "  9) 1.13.2"
echo "  10) 1.12.2"
echo "  11) 1.11.2"
echo "  12) 1.10.2"
echo "  13) 1.9.4"
echo "  14) 1.8.8"

read -p "Choose an option: " Option_B
case $Option_B in
1 | 1.21)
    Version="1.21"
    ;;
2 | 1.20 | 1.20.6)
    Version="1.20.6"
    ;;
3 | 1.19 | 1.19.4)
    Version="1.19.4"
    ;;
4 | 1.18 | 1.18.2)
    Version="1.18.2"
    ;;
5 | 1.17 | 1.17.1)
    Version="1.17.1"
    ;;
6 | 1.16 | 1.16.5)
    Version="1.16.5"
    ;;
7 | 1.15 | 1.15.2)
    Version="1.15.2"
    ;;
8 | 1.14 | 1.14.4)
    Version="1.14.4"
    ;;
9 | 1.13 | 1.13.2)
    Version="1.13.2"
    ;;
10 | 1.12 | 1.12.2)
    Version="1.12.2"
    ;;
11 | 1.11 | 1.11.2)
    Version="1.11.2"
    ;;
12 | 1.10 | 1.10.2)
    Version="1.10.2"
    ;;
13 | 1.9 | 1.9.4)
    Version="1.9.4"
    ;;
14 | 1.8 | 1.8.8)
    Version="1.8.8"
    ;;
*)
    echo "Exiting the script, no changes have been made"
    exit 1
    ;;
esac

echo -e "$LIME_YELLOW\nGetting latest Paper Minecraft server...$NORMAL"
BuildJSON=$(curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" https://papermc.io/api/v2/projects/paper/versions/$Version)
Build=$(echo "$BuildJSON" | rev | cut -d, -f 1 | cut -d] -f 2 | rev)
Build=$(($Build + 0))

echo -e "$LIME_YELLOW\nDownloading PaperMC...$NORMAL"
curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4.212 Safari/537.36" -o paperclip.jar "https://papermc.io/api/v2/projects/paper/versions/$Version/builds/$Build/downloads/paper-$Version-$Build.jar"

if [ "$clean_install" = "yes" ]; then
    echo -e "$LIME_YELLOW\nDownloading Java JDK...$NORMAL"
    wget -O java_install.tar.gz https://download.oracle.com/java/22/latest/jdk-22_linux-aarch64_bin.tar.gz
    echo -e "$LIME_YELLOW\nUnzipping Java JDK...$NORMAL"
    sudo tar -xzf java_install.tar.gz
    java_dir=~/minecraft/jdk*

    echo -e "$LIME_YELLOW\nJava version:$NORMAL"
    $java_dir/bin/java -version

    echo -e "$LIME_YELLOW\nChecking for total memory available...$NORMAL"
    TotalMemory=$(awk '/MemTotal/ { printf "%.0f\n", $2/1024 }' /proc/meminfo)
    echo "  TotalMemory = $TotalMemory MB"

    read -p "Available RAM (in MB): " A_RAM

    echo -e "$LIME_YELLOW\nDownloading start.sh...$NORMAL"
    wget -O start.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/start.sh
    echo /usr/bin/screen -dmS minecraft $java_dir/bin/java -jar -Xms${A_RAM}M -Xmx${A_RAM}M -Dcom.mojang.eula.agree=true ~/minecraft/paperclip.jar >>start.sh
    chmod +x start.sh

    echo -e "$LIME_YELLOW\nDownloading restart.sh...$NORMAL"
    wget -O restart.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/restart.sh
    echo sudo rm ~/minecraft/paperclip.jar >>restart.sh
    echo wget -O paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download >>restart.sh
    echo "echo 'Rebooting the server now...'" >>restart.sh
    echo sudo reboot >>restart.sh
    chmod +x restart.sh

    echo -e "$LIME_YELLOW\nDownloading stop.sh...$NORMAL"
    wget -O stop.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/stop.sh
    chmod +x stop.sh

    echo -e "$LIME_YELLOW\nDownloading optimize_server.sh...$NORMAL"
    wget -O optimize_server.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/optimize_server.sh
    chmod +x optimize_server.sh

    echo -e "$LIME_YELLOW\nConfiguring server.properties file$NORMAL"

    read -p 'Server Name: ' servername
    echo "server-name=$servername" >server.properties
    echo "motd=$servername" >>server.properties

    echo -e "$LIME_YELLOW\nSelect a gamemode for your server$NORMAL"
    echo "  1) Survival"
    echo "  2) Creative"
    read -p "Choose an option: " servermode

    case $servermode in
    1 | survival) echo "gamemode=survival" >>server.properties ;;
    2 | creative) echo "gamemode=creative" >>server.properties ;;
    *) echo "gamemode=survival" >>server.properties ;;
    esac

    echo -e "$LIME_YELLOW\nSelect a difficulty for your server$NORMAL"
    echo "  1) Peaceful"
    echo "  2) Easy"
    echo "  3) Normal"
    echo "  4) Hard"
    read -p "Choose an option: " serverdiff

    case $serverdiff in
    1 | peaceful) echo "difficulty=peaceful" >>server.properties ;;
    2 | easy) echo "difficulty=easy" >>server.properties ;;
    3 | normal) echo "difficulty=normal" >>server.properties ;;
    4 | hard) echo "difficulty=hard" >>server.properties ;;
    *) echo "difficulty=normal" >>server.properties ;;
    esac

    echo -e "$LIME_YELLOW\nSelect a world type for your server$NORMAL"
    echo "  1) Default"
    echo "  2) Flat"
    echo "  3) LargeBiomes"
    echo "  4) Amplified"
    read -p "Choose an option: " servertype

    case $servertype in
    2 | flat) echo "level-type=flat" >>server.properties ;;
    3 | largeBiomes) echo "level-type=largeBiomes" >>server.properties ;;
    4 | amplified) echo "level-type=amplified" >>server.properties ;;
    *) echo "level-type=default" >>server.properties ;;
    esac

    read -p "Hardcore mode? (you can't revive when you die) yes/no: " serverhard
    if [[ "$serverhard" = "yes" || "$serverhard" = "y" ]]; then
        echo "hardcore=true" >>server.properties
    fi

    read -p "Enable PvP? (attacks between players) yes/no: " serverpvp
    if [[ "$serverpvp" = "no" || "$serverpvp" = "n" ]]; then
        echo "pvp=false" >>server.properties
    fi

    read -p "Support pirate players? yes/no: " serveronline
    if [[ "$serveronline" = "yes" || "$serveronline" = "y" ]]; then
        echo "online-mode=false" >>server.properties

        read -p "Do you want to download the SkinsRestorer plugin? yes/no: " downloadskinsrestorer
        if [[ "$downloadskinsrestorer" = "yes" || "$downloadskinsrestorer" = "y" ]]; then
            echo -e "$LIME_YELLOW\nDownloading SkinsRestorer plugin...$NORMAL"
            PLUGIN_DIR="$HOME/minecraft/plugins"
            mkdir -p $PLUGIN_DIR
            LATEST_RELEASE=$(curl -s https://api.github.com/repos/SkinsRestorer/SkinsRestorer/releases/latest)
            ASSET_URL=$(echo $LATEST_RELEASE | grep -oP '"browser_download_url": "\K(.*?)(?=")' | grep "SkinsRestorer.jar")
            if [ -n "$ASSET_URL" ]; then
                curl -L -o $PLUGIN_DIR/SkinsRestorer.jar $ASSET_URL
                echo "SkinsRestorer plugin downloaded successfully."
            else
                echo "Failed to find SkinsRestorer plugin URL."
            fi
        fi
    fi

    read -p "Maximum number of players: " servermax
    if [ $servermax -gt 0 ]; then
        echo "max-players=$servermax" >>server.properties
    fi

    echo "snooper-enabled=false" >>server.properties
    echo "network-compression-threshold=512" >>server.properties
    echo "max-tick-time=120000" >>server.properties
    echo "spawn-protection=0" >>server.properties

    echo -e "\nBuilding the Minecraft server...$NORMAL"
    $java_dir/bin/java -jar -Xms800M -Xmx800M ~/minecraft/paperclip.jar

    echo -e "$LIME_YELLOW\nAccepting the EULA...$NORMAL"
    echo eula=true >eula.txt
fi

# Configuración del servicio de inicio automático
echo -e "$LIME_YELLOW\nConfiguring Minecraft service...$NORMAL"
sudo curl -H "Accept-Encoding: identity" -L -o /etc/systemd/system/minecraft.service https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/minecraft.service
sudo sed -i "s:userxname:$USER:g" /etc/systemd/system/minecraft.service
sudo sed -i "s:dirname:$HOME:g" /etc/systemd/system/minecraft.service
sudo systemctl daemon-reload

echo -n "Start Minecraft server at startup automatically (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ]; then
    sudo systemctl enable minecraft.service
fi

# Configuración de reinicios automáticos
echo -n "Automatically reboot the server and update Minecraft at 4am daily (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ]; then
    croncmd="$HOME/minecraft/restart.sh"
    cronjob="0 4 * * * $croncmd 2>&1"
    (
        crontab -l | grep -v -F "$croncmd"
        echo "$cronjob"
    ) | crontab -
    echo -e "$LIME_YELLOW\nDaily reboot scheduled. To change time or remove automatic reboot, type crontab -e$NORMAL"
fi

echo -e "$LIME_YELLOW\nSetup is complete. To run the server, go to the Minecraft directory and type ./start.sh"
echo "Don't forget to set up port forwarding on your router. The default port is 25565.$NORMAL"
