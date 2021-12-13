# Minecraft Server 1.8.8 - 1.18.1 for ARM64

script for an easy creation and configuration of a server for minecraft with paperMC in ARM64

##### I have relied on the scripts of:
- James A. Chambers - https://github.com/TheRemote/RaspberryPiMinecraft
- Marc Tönsing - https://github.com/mtoensing/RaspberryPiMinecraft

##### so far it has been tested with:
-Nvidia Jetson Nano 4Gb
-Raspberry pi 4B 4GB

if you have tested on another board, please add to this list

## Install Minecraft server

	wget -O SetupMinecraft.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/SetupMinecraft.sh
	chmod +x SetupMinecraft.sh
	./SetupMinecraft.sh
In the case that you already have to create a server, this same script allows you to delete and reinstall the server or update the server

## Start the server
	cd ~/minecraft
	./start.sh

## Start the low spec server
	#this script is created on boards where needed
	cd ~/minecraft
	./start_lowspec.sh

## Restart the server
	cd ~/minecraft
	./restart.sh
	
### Basic screen usage on your server
	#once your server is started, you can enter the server command console with this command
	screen -r minecraft
	#and to exit press Ctrl + A then Ctrl + D


	 #to know if your server started correctly use
	screen -ls
	#if "minecraft" is among the results, it means that your server ran correctly

All the text in English is translated with Google Translator, do not hesitate to propose changes if something is wrongly translated

# Minecraft Server 1.8.8 - 1.18.1 en ARM64 (Español)

Script para una fácil instalación y configuración de un servidor de minecraft con papperMC en placas ARM64

##### Me he basado en los siguientes repositorios:
- James A. Chambers - https://github.com/TheRemote/RaspberryPiMinecraft
- Marc Tönsing - https://github.com/mtoensing/RaspberryPiMinecraft

##### Hasta el momento se ha probado con las siguientes placas:
-Nvidia Jetson Nano 4Gb
-Raspberry pi 4B 4GB

si usted ha probado otra placa, por favor, agreguela a esta lista

## Instalación del servidor

	wget -O SetupMinecraft.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/SetupMinecraft.sh
	chmod +x SetupMinecraft.sh
	./SetupMinecraft.sh
en el caso de que ya tenga un servidor creado, este script también permite actualizar el servidor o eliminar y volver a instalar

## Iniciar el servidor
	cd ~/minecraft
	./start.sh

## Iniciar el servidor de bajos recursos
	#este script solo se crea cuando su placa lo necesita
	cd ~/minecraft
	./start_lowspec.sh

## Reiniciar el servidor
	cd ~/minecraft
	./restart.sh
	
### Uso básico de screen para su servidor
	#cuando inicie su servidor, puede acceder a la consola de comando ejecutando este comando en el terminal
	screen -r minecraft
	#y puede salir presionando Ctrl+A luego Ctrl+D


	 #para saber si su servidor está activo puede usar este comando
	screen -ls
	#si "minecraft" sale en el listado de resultado, quiere decir que su servidor está activo


