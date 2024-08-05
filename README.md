# Minecraft Server 1.8.8 - 1.21 for ARM64

Script for easy creation and configuration of a Minecraft server with PaperMC on ARM64.

##### This script is based on the following repositories:
- James A. Chambers - https://github.com/TheRemote/RaspberryPiMinecraft
- Marc Tönsing - https://github.com/mtoensing/RaspberryPiMinecraft

##### Tested with:
- Nvidia Jetson Nano 4GB
- Raspberry Pi 4B 4GB
- Raspberry Pi 4B 8GB

If you have tested it on another board, please add it to this list.

## Install Minecraft server

```sh
wget -O SetupMinecraft.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/SetupMinecraft.sh
chmod +x SetupMinecraft.sh
./SetupMinecraft.sh
```

If you already have a server created, this script allows you to delete and reinstall the server or update the server.

## Start the server

```sh
cd ~/minecraft
./start.sh
```

## Restart the server

```sh
cd ~/minecraft
./restart.sh
```

### Basic screen usage on your server

Once your server is started, you can enter the server command console with this command:

```sh
screen -r minecraft
```

To exit, press `Ctrl + A` then `Ctrl + D`.

To check if your server started correctly, use:

```sh
screen -ls
```

If "minecraft" is among the results, it means that your server ran correctly.

---

# Minecraft Server 1.8.8 - 1.21 en ARM64 (Español)

Script para una fácil instalación y configuración de un servidor de Minecraft con PaperMC en placas ARM64.

##### Me he basado en los siguientes repositorios:
- James A. Chambers - https://github.com/TheRemote/RaspberryPiMinecraft
- Marc Tönsing - https://github.com/mtoensing/RaspberryPiMinecraft

##### Probado con:
- Nvidia Jetson Nano 4GB
- Raspberry Pi 4B 4GB
- Raspberry Pi 4B 8GB

Si usted ha probado otra placa, por favor, agrégala a esta lista.

## Instalación del servidor

```sh
wget -O SetupMinecraft.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/SetupMinecraft.sh
chmod +x SetupMinecraft.sh
./SetupMinecraft.sh
```

En el caso de que ya tenga un servidor creado, este script también permite actualizar el servidor o eliminar y volver a instalar.

## Iniciar el servidor

```sh
cd ~/minecraft
./start.sh
```

## Reiniciar el servidor

```sh
cd ~/minecraft
./restart.sh
```

### Uso básico de screen para su servidor

Cuando inicie su servidor, puede acceder a la consola de comandos ejecutando este comando en el terminal:

```sh
screen -r minecraft
```

Y puede salir presionando `Ctrl+A` luego `Ctrl+D`.

Para saber si su servidor está activo, puede usar este comando:

```sh
screen -ls
```

Si "minecraft" sale en el listado de resultados, quiere decir que su servidor está activo.


