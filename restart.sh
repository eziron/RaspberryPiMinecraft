#!/bin/bash
# Author: James A. Chambers - https://jamesachambers.com/
# More information at https://jamesachambers.com/raspberry-pi-minecraft-server-script-with-startup-service/
# GitHub Repository: https://github.com/TheRemote/RaspberryPiMinecraft
# Adapted by Eziron
# Minecraft Server restart script - primarily called by minecraft service but can be ran manually with ./restart.sh

# Check to make sure we aren't running as root
if [[ $(id -u) = 0 ]]; then
   echo "This script is not meant to run as root or sudo. Please run as a normal user with ./restart.sh. Exiting..."
   exit 1
fi

# Check if server is running
if ! screen -list | grep -q "\.minecraft"; then
    echo "Server is not currently running!"
    exit 1
fi

echo "Sending restart notifications to server..."

# Minecraft Server restart and system reboot.
screen -Rd minecraft -X stuff "say Server is restarting in 30 seconds! $(printf '\r')"
sleep 23s
screen -Rd minecraft -X stuff "say Server is restarting in 7 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 6 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 5 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 4 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 3 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 2 seconds! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Server is restarting in 1 second! $(printf '\r')"
sleep 1s
screen -Rd minecraft -X stuff "say Closing server...$(printf '\r')"
screen -Rd minecraft -X stuff "stop$(printf '\r')"

# Wait up to 30 seconds for server to close
echo "Closing server..."
StopChecks=0
while [ $StopChecks -lt 30 ]; do
  if ! screen -list | grep -q "\.minecraft"; then
    break
  fi
  sleep 1
  StopChecks=$((StopChecks+1))
done

cd ~/minecraft
tar -zcvf /home/pi/minecraft_backup.tar.gz minecraft/
echo "Backup created."

# Archivo que guarda la versión actual
VERSION_FILE=current_version.txt

# 1. Verificar si el archivo existe
if [ ! -f "$VERSION_FILE" ]; then
  echo "Error: Version file ($VERSION_FILE) not found." >&2
  exit 1
fi

# 2. Leer el archivo en la variable Version
Version=$(cat "$VERSION_FILE")

# 3. Verificar si la variable quedó vacía después de leer
if [ -z "$Version" ]; then
  echo "Error: Version file ($VERSION_FILE) exists but is empty or unreadable." >&2
  exit 1
fi

echo -e "\nGetting latest Paper Minecraft server for $Version..."

# Usa jq para parsear la respuesta JSON y obtener el último número de compilación estable
echo -e "\nGetting latest stable Paper build number for $Version..."
Build=$(curl -s -X GET "https://api.papermc.io/v2/projects/paper/versions/$Version/builds" -H 'accept: application/json' | jq -r '.builds | map(select(.channel == "default") | .build) | .[-1]')

# Comprueba si se encontró un número de compilación estable válido
if [[ "$Build" == "null" || -z "$Build" ]]; then
    echo -e "\nWarning: No stable build found for Minecraft version $Version."
    echo -e "Attempting to fetch the latest build (might be unstable)..."
    Build=$(curl -s -X GET "https://api.papermc.io/v2/projects/paper/versions/$Version/builds" -H 'accept: application/json' | jq -r '.builds[-1].build')
    if [[ "$Build" == "null" || -z "$Build" ]]; then
         echo -e "\nError: No build found for Minecraft version $Version at all. Exiting."
         exit 1
    fi
    echo -e "Found latest build (possibly unstable): $Build"
else
     echo -e "Latest stable build is $Build"
fi

# Construye el nombre del archivo JAR y la URL de descarga
JarName="paper-$Version-$Build.jar"
DownloadURL="https://api.papermc.io/v2/projects/paper/versions/$Version/builds/$Build/downloads/$JarName"

echo -e "\nDownloading PaperMC $Version build $Build..."
curl -L -o paperclip.jar "$DownloadURL"

# Comprueba si la descarga fue exitosa (comprobación básica: archivo existe y no está vacío)
if [ ! -s paperclip.jar ]; then
    echo -e "\nError: Failed to download PaperMC jar from $DownloadURL. Exiting."
    # Opcional: limpiar archivo vacío
    rm -f paperclip.jar
    exit 1
fi
echo -e "\nPaperMC downloaded successfully."

