#!/bin/bash

#script for an easy creation and configuration of a server for minecraft with paperMC in ARM64 by Eziron
# 1.17 - 1.8.8    date:30/06/2021

# I have relied on the scripts of:
# James A. Chambers - https://github.com/TheRemote/RaspberryPiMinecraft
# Marc Tönsing - https://github.com/mtoensing/RaspberryPiMinecraft

# Terminal colors
LIME_YELLOW=$(tput setaf 190)
NORMAL=$(tput sgr0)


cd ~

echo -e "$LIME_YELLOW \ninstallation script for minecraft PaperMC server on linux ARM64 by Eziron $NORMAL"

echo -e "$LIME_YELLOW \nUpdating packages... $NORMAL"
sudo apt-get update

echo -e "$LIME_YELLOW \nInstalling screen... $NORMAL"
sudo apt-get install screen -y

if [ -d "minecraft" ]; then
    echo -e "$LIME_YELLOW\nDirectory minecraft already exists! "

    echo -e "\nwhat to do $NORMAL"
    echo "1) clean and restart all"
    echo "2) update/upgrade"
    echo "3) exit"
    read -p "choose an option: " Option_A
    
    case $Option_A in
        1|clean|restart|"clean and restart all")
            echo -e "\ndeleting all files from server  (~/minecraft) ..."
            sudo rm -rf ~/minecraft/
            clean_install="yes" 
            echo "Creating minecraft server directory  (~/minecraft) ..."
            mkdir ~/minecraft ;;

        2|update|upgrade|"update/upgrade")
            echo -e "\ndeleting some files from the server for update..."
            sudo rm -rf ~/minecraft/jdk* ~/minecraft/java* ~/minecraft/start.sh ~/minecraft/start_lowspec.sh
            clean_install="no" ;;

        3|exit|*)
            echo -e "\nexiting the script, no changes have been made"
            exit 1;;
    esac
else
    clean_install="yes" 
    echo "Creating minecraft server directory (~/minecraft) ..."
    mkdir minecraft
fi

cd ~/minecraft

echo -e "$LIME_YELLOW\nWhat version do you want to install? $NORMAL"
echo "  1) 1.17"
echo "  2) 1.16.5"
echo "  3) 1.15.2"
echo "  4) 1.14.4"
echo "  5) 1.13.2"
echo "  6) 1.12.2"
echo "  7) 1.11.2"
echo "  8) 1.10.2"
echo "  9) 1.9.4"
echo "  10) 1.8.8"

read -p "choose an option: " Option_B
case $Option_B in
    1|1.17)
        Version="1.17";;

    2|1.16|1.16.5)
        Version="1.16.5";;

    3|1.15|1.15.2)
        Version="1.15.2";;

    4|1.14|1.14.4)
        Version="1.14.4";;
    
    5|1.13|1.13.2)
        Version="1.13.2";;

    6|1.12|1.12.2)
        Version="1.12.2";;

    7|1.11|1.11.2)
        Version="1.11.2";;

    8|1.10|1.10.2)
        Version="1.10.2";;

    9|1.9|1.9.4)
        Version="1.9.4";;

    10|1.8|1.8.8)
        Version="1.8.8";;

    *)
        echo "exiting the script, no changes have been made"
        exit 1;;
esac

echo -e "$LIME_YELLOW\ndownload paperMC... $NORMAL"
wget -O paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download


#https://jdk.java.net/16/
echo -e "$LIME_YELLOW\ndownload java openjdk 16... $NORMAL"
wget -O java16_install.tar.gz https://download.java.net/java/GA/jdk16.0.1/7147401fd7354114ac51ef3e1328291f/9/GPL/openjdk-16.0.1_linux-aarch64_bin.tar.gz
echo -e "$LIME_YELLOW\nunzip java openjdk 16... $NORMAL"
sudo tar -xzf java16_install.tar.gz
java_dir=~/minecraft/jdk-16.0.1

echo -e "$LIME_YELLOW\njava version: $NORMAL"
$java_dir/bin/java -version

#Download normal start script
echo -e "$LIME_YELLOW \nDownload start.sh ... $NORMAL"
wget -O start.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/start.sh

echo /usr/bin/screen -dmS minecraft $java_dir/bin/java -jar -Xms2500M -Xmx2500M -Dcom.mojang.eula.agree=true ~/minecraft/paperclip.jar >> start.sh
chmod +x start.sh

echo -e "$LIME_YELLOW\nChecking for total memory available...$NORMAL"
TotalMemory=$(awk '/MemTotal/ { printf "%.0f\n", $2/1024 }' /proc/meminfo)
echo "  TotalMemory = $TotalMemory"
if [ $TotalMemory -lt 3000 ]; then
  #Download low spec start script
  echo -e "$LIME_YELLOW\nDownload low spec start.sh ... $NORMAL"
  wget -O start_lowspec.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/start_lowspec.sh

  echo /usr/bin/screen -dmS minecraft $java_dir/bin/java -jar -Xms800M -Xmx800M -Dcom.mojang.eula.agree=true ~/minecraft/paperclip.jar >> start_lowspec.sh
  chmod +x start_lowspec.sh
fi

#Download Restar script
echo -e "$LIME_YELLOW\nDownload restar.sh ... $NORMAL"
wget -O restart.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/restart.sh

echo sudo rm ~/minecraft/paperclip.jar >> restart.sh
echo wget -O paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download >> restart.sh
echo echo "rebooting the board now..." >> restart.sh
echo sudo reboot >> restart.sh
chmod +x restart.sh

#Download optimization script
echo -e "$LIME_YELLOW\nDownload optimize_server.sh ... $NORMAL"
wget -O optimize_server.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/optimize_server.sh

echo sudo rm ~/minecraft/paperclip.jar >> optimize_server.sh
echo wget -O paperclip.jar https://papermc.io/api/v1/paper/$Version/latest/download >> optimize_server.sh
chmod +x optimize_server.sh

if  [ "$clean_install" = "yes" ]; then
  echo -e "$LIME_YELLOW\nConfigure server.properties file$NORMAL"

  #Configure server-name and motd in server.properties
  echo -e "$LIME_YELLOW\nEnter a name for your server $NORMAL"
  read -p '   Server Name: ' servername
  echo "server-name=$servername" > server.properties
  echo "motd=$servername" >> server.properties


  #Configure gamemode in server.properties
  echo -e "$LIME_YELLOW\nEnter a gamemode for your server $NORMAL"
  echo "  1) survival"
  echo "  2) creative"
  read -p "choose an option: " servermode

  case $servermode in
    1|survival)  echo "gamemode=survival"  >> server.properties;;
    2|creative)  echo "gamemode=creative"  >> server.properties;;
    *) echo "set gamemode by default"
  esac

  #Configure difficulty in server.properties
  echo -e "$LIME_YELLOW\nEnter a difficulty for your server $NORMAL"
  echo "  1) peaceful"
  echo "  2) easy"
  echo "  3) normal"
  echo "  4) hard"
  read -p "choose an option: " serverdiff

  case $serverdiff in
    1|peaceful) echo "difficulty=peaceful" >> server.properties;;
    2|easy)     echo "difficulty=easy"     >> server.properties;;
    3|normal)   echo "difficulty=normal"   >> server.properties;;
    4|hard)     echo "difficulty=hard"     >> server.properties;;
    *) echo "set difficulty by default"
  esac

  #Configure level-type in server.properties
  echo -e "$LIME_YELLOW\nWhat kind of world do you want on your server? $NORMAL"
  echo "  1) default"
  echo "  2) flat"
  echo "  3) largeBiomes"
  echo "  4) amplified"
  read -p "choose an option: " servertype

  case $servertype in
    2|flat)     echo "level-type=flat"     >> server.properties;;
    3|largeBiomes)   echo "level-type=largeBiomes"   >> server.properties;;
    4|amplified)     echo "level-type=amplified"     >> server.properties;;
    *) echo "set difficulty by default"
  esac

  #Configure hardcore in server.properties
  echo -e "$LIME_YELLOW\n(you can't revive when you die)"
  read -p "hardcore? yes/no: " serverhard
  if  [[ "$serverhard" = "yes" || "$serverhard" = "y" ]]; 
  then
    echo "hardcore=true"  >> server.properties
  fi

  #Configure pvp in server.properties
  echo -e "$\n(attacks between players)"
  read -p "pvp? yes/no: " serverpvp
  if  [[ "$serverpvp" = "no" || "$serverpvp" = "n" ]]; 
  then
    echo "pvp=false"  >> server.properties
  fi

  #Configure online-mode in server.properties
  read -p "do you want to support pirate players? yes/no: " serveronline
  if  [[ "$serveronline" = "yes" || "$serveronline" = "y" ]]; 
  then
    echo "online-mode=false"  >> server.properties
  fi

  #Configure max-players in server.properties
  read -p "maximum number of players?: " servermax
  if [ $servermax -gt 0 ]; then
    echo "max-players=$servermax"  >> server.properties
  fi

  #and other recommended settings
  echo "snooper-enabled=false"  >> server.properties
  echo "network-compression-threshold=512" >> server.properties
  echo "max-tick-time=120000" >> server.properties
  echo "spawn-protection=0/g" >> server.properties

  #running the server to generate the world
  echo -e "\nBuilding the Minecraft server... $NORMAL"
  $java_dir/bin/java -jar -Xms800M -Xmx800M ~/minecraft/paperclip.jar

  echo "$LIME_YELLOW Accepting the EULA... $NORMAL"
  echo eula=true > eula.txt
fi

echo "$LIME_YELLOW Setup is complete. To run the server go to the minecraft directory and type ./start.sh"
echo " Don't forget to set up port forwarding on your router. The default port is 25565 $NORMAL"

