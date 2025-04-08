# Servidor Minecraft PaperMC para ARM64 (Raspberry Pi / Jetson Nano y más)

Este repositorio contiene scripts para facilitar la creación, configuración y gestión de un servidor de Minecraft utilizando PaperMC, optimizado para dispositivos ARM64 como Raspberry Pi (4B o superior) y Nvidia Jetson Nano.

**Basado en los trabajos de:**
*   James A. Chambers - [RaspberryPiMinecraft](https://github.com/TheRemote/RaspberryPiMinecraft)
*   Marc Tönsing - [RaspberryPiMinecraft](https://github.com/mtoensing/RaspberryPiMinecraft)

**Probado con:**
*   Nvidia Jetson Nano 4GB
*   Raspberry Pi 4B 4GB
*   Raspberry Pi 4B 8GB
*   Raspberry Pi 5 8GB

(Si has probado con éxito en otra placa ARM64, ¡considera contribuir actualizando esta lista!)

---

## Índice

1.  [Requisitos Previos](#requisitos-previos)
2.  [Guía Rápida: Instalación de Raspberry Pi OS Lite (64 bits) y Configuración SSH (Opcional)](#guía-rápida-instalación-de-raspberry-pi-os-lite-64-bits-y-configuración-ssh-opcional)
3.  [Instalación del Servidor Minecraft](#instalación-del-servidor-minecraft)
4.  [Gestión del Servidor](#gestión-del-servidor)
    *   [Iniciar el Servidor](#iniciar-el-servidor)
    *   [Detener el Servidor](#detener-el-servidor)
    *   [Reiniciar el Servidor (y hacer backup)](#reiniciar-el-servidor-y-hacer-backup)
    *   [Acceder a la Consola del Servidor](#acceder-a-la-consola-del-servidor)
    *   [Verificar si el Servidor está Activo](#verificar-si-el-servidor-está-activo)
5.  [Optimización del Servidor (Opcional)](#optimización-del-servidor-opcional)
6.  [Actualizar el Servidor](#actualizar-el-servidor)
7.  [Gestionar el Servicio (Inicio Automático)](#gestionar-el-servicio-inicio-automático)
8.  [Gestionar Reinicios Automáticos (Cron)](#gestionar-reinicios-automáticos-cron)
9.  [Notas Importantes](#notas-importantes)

---

## Requisitos Previos

*   Una placa ARM64 compatible (Raspberry Pi 4/5, Jetson Nano, etc.).
*   Una tarjeta microSD de buena calidad (32GB mínimo recomendado, Clase A1/A2 preferible).
*   Fuente de alimentación adecuada para tu placa.
*   Conexión a internet estable.
*   Un sistema operativo Linux de 64 bits instalado (Raspberry Pi OS Lite 64-bit es recomendado para mejor rendimiento).
*   Acceso a la terminal de tu dispositivo (directamente o vía SSH).

---

## Guía Rápida: Instalación de Raspberry Pi OS Lite (64 bits) y Configuración SSH (Opcional)

**¿Ya tienes tu Raspberry Pi con un OS de 64 bits y acceso SSH configurado?** ¡Perfecto! Puedes [saltar directamente a la Instalación del Servidor Minecraft](#instalación-del-servidor-minecraft).

Esta guía es para usuarios que empiezan desde cero con una Raspberry Pi:

1.  **Descargar Raspberry Pi Imager:** Obtén la herramienta oficial desde [aquí](https://www.raspberrypi.com/software/). Instálala en tu ordenador (Windows, macOS o Linux).
2.  **Abrir Raspberry Pi Imager:** Ejecuta la aplicación.
3.  **Elegir Dispositivo:** Selecciona tu modelo de Raspberry Pi (ej. Raspberry Pi 4, Raspberry Pi 5). Es **crucial** elegir un modelo compatible con 64 bits.
4.  **Elegir Sistema Operativo (OS):**
    *   Haz clic en `ELEGIR OS`.
    *   Ve a `Raspberry Pi OS (other)`.
    *   Selecciona `Raspberry Pi OS Lite (64-bit)`. Esta versión no tiene escritorio gráfico, lo que libera más recursos para tu servidor Minecraft. (Otras versiones de 64 bits también funcionarán, pero consumirán más RAM).
5.  **Elegir Almacenamiento:** Inserta tu tarjeta microSD en el ordenador y selecciónala en el Imager. **¡CUIDADO! Esto borrará todo el contenido de la tarjeta.**
6.  **Configuración Personalizada:** Haz clic en `SIGUIENTE`. Aparecerá una ventana preguntando: "¿Desea aplicar ajustes personalizados del SO?". Selecciona `EDITAR AJUSTES`.
7.  **Pestaña "General":**
    *   **Nombre de Host:** Puedes dejar `raspberrypi` o cambiarlo. La dirección local será `tunombredehost.local` (ej. `raspberrypi.local`).
    *   **Usuario y Contraseña:** Establece un nombre de usuario y una contraseña segura. Si no lo haces, los predeterminados son `pi` y `raspberry` (¡recomendable cambiarlos!).
    *   **Configurar LAN inalámbrica:** Marca esta casilla si usarás WiFi. Introduce el nombre (SSID) y la contraseña de tu red WiFi. Selecciona tu país.
8.  **Pestaña "Servicios":**
    *   **Activar SSH:** Marca esta opción.
    *   Selecciona "Usar autenticación por contraseña".
9.  **Guardar y Escribir:**
    *   Haz clic en `GUARDAR`.
    *   Confirma con `SÍ` en la advertencia sobre la configuración.
    *   Confirma con `SÍ` en la advertencia sobre el borrado de la tarjeta SD.
10. **Esperar:** El proceso de descarga y escritura del OS en la microSD tardará unos minutos.
11. **Expulsar e Insertar:** Una vez finalizado, expulsa de forma segura la microSD del ordenador e insértala en tu Raspberry Pi apagada.
12. **Encender y Conectar:** Conecta el cable de red (si usas Ethernet) y la fuente de alimentación a tu Raspberry Pi. Dale unos minutos para que arranque por primera vez y se conecte a tu red.
13. **Conexión SSH:** Abre una terminal o PowerShell en tu ordenador y conéctate usando SSH:
    ```sh
    ssh tu_usuario@tu_nombre_de_host.local
    ```
    *   Reemplaza `tu_usuario` por el nombre de usuario que configuraste (o `pi` si usaste el predeterminado).
    *   Reemplaza `tu_nombre_de_host.local` por el nombre de host que configuraste seguido de `.local` (o `raspberrypi.local` si usaste el predeterminado).
    *   Ejemplo con predeterminados: `ssh pi@raspberrypi.local`

    *   Si recibes un error como `Could not resolve hostname`, espera un poco más o verifica que la Pi esté conectada a la red y el nombre de host sea correcto.
    *   La primera vez, te preguntará si confías en la huella digital del host, escribe `yes` y presiona Enter.
    *   Introduce la contraseña que configuraste (o `raspberry` si usaste la predeterminada). **Nota:** No verás los caracteres al escribir la contraseña. Presiona Enter.

14. **¡Conectado!** Si ves el prompt de la terminal de tu Raspberry Pi (ej. `tu_usuario@tu_nombre_de_host:~ $`), ¡lo has conseguido!

✅ ¡Ahora estás listo para continuar con la instalación del servidor! Vuelve a la sección siguiente.

---

<a id="instalación-del-servidor-minecraft"></a>
## Instalación del Servidor Minecraft

1.  **Actualizar el Sistema Operativo:** Es una buena práctica mantener tu sistema actualizado. Ejecuta los siguientes comandos en la terminal de tu dispositivo:
    ```sh
    sudo apt update
    sudo apt upgrade -y
    ```
2.  **Descargar y Ejecutar el Script de Instalación:**
    ```sh
    wget -O SetupMinecraft.sh https://raw.githubusercontent.com/Eziron/RaspberryPiMinecraft/master/SetupMinecraft.sh
    chmod +x SetupMinecraft.sh
    ./SetupMinecraft.sh
    ```
3.  **Seguir las Instrucciones del Script:** El script te guiará a través de varias opciones:
    *   **Directorio existente:** Si ya existe una carpeta `~/minecraft`, te preguntará si quieres:
        *   `1) Limpiar y reinstalar todo`: Borra la carpeta existente y empieza de cero.
        *   `2) Actualizar/Mejorar`: Mantiene tus datos y actualiza el servidor (ver sección [Actualizar el Servidor](#actualizar-el-servidor)).
        *   `3) Salir`: Aborta la instalación.
    *   **Versión de Minecraft:** Podrás elegir la versión de PaperMC que deseas instalar. Las versiones disponibles (según el script actual) son:
        *   1.21.4
        *   1.20.6
        *   1.19.4
        *   1.18.2
        *   1.17.1
        *   1.16.5
        *   1.15.2
        *   1.14.4
        *   1.13.2
        *   1.12.2
        *   1.11.2
        *   1.10.2
        *   1.9.4
        *   1.8.8
    *   **Descarga de Java:** Si es una instalación limpia, descargará e instalará una versión compatible de Java JDK.
    *   **Memoria RAM:** Te preguntará cuánta memoria RAM (en MB) quieres asignar al servidor. Elige una cantidad razonable dejando algo de memoria para el sistema operativo (ej., si tienes 4GB (aprox. 3900MB), podrías asignar 2500MB o 3000MB).
    *   **Descarga de Scripts:** Descargará los scripts necesarios (`start.sh`, `restart.sh`, `stop.sh`, `optimize_server.sh`).
    *   **Configuración Inicial (`server.properties`):** Te pedirá configurar:
        *   Nombre del servidor (motd)
        *   Modo de juego (Survival, Creative)
        *   Dificultad (Peaceful, Easy, Normal, Hard)
        *   Tipo de mundo (Default, Flat, LargeBiomes, Amplified)
        *   Modo Hardcore (sí/no)
        *   PvP (sí/no)
        *   Soporte para jugadores no premium ("pirata") (sí/no).
            *   Si eliges `sí` (online-mode=false), te preguntará si quieres descargar el plugin `SkinsRestorer` para ver las skins.
        *   Número máximo de jugadores.
    *   **Primer Arranque y EULA:** Realizará un breve arranque para generar archivos y aceptará automáticamente el EULA de Mojang.
    *   **Servicio de Inicio Automático:** Te preguntará si deseas que el servidor se inicie automáticamente cuando el sistema arranque (`systemctl enable minecraft.service`).
    *   **Reinicios Automáticos:** Te preguntará si deseas programar un reinicio diario (por defecto a las 4 AM) que también actualiza el servidor y realiza un backup.

4.  **¡Instalación Completa!** Una vez finalizado el script, tu servidor estará instalado en el directorio `~/minecraft`.

---

## Gestión del Servidor

Todos los comandos de gestión deben ejecutarse desde el directorio del servidor:

```sh
cd ~/minecraft
```

### Iniciar el Servidor

```sh
./start.sh
```

Esto iniciará el servidor dentro de una sesión de `screen` llamada `minecraft`, permitiendo que se ejecute en segundo plano.

### Detener el Servidor

```sh
./stop.sh
```

Esto envía el comando `stop` a la consola del servidor de forma segura y espera a que se cierre.

### Reiniciar el Servidor (y hacer backup)

```sh
./restart.sh
```

**¡Importante!** Este script realiza las siguientes acciones:

1. Envía mensajes de aviso de reinicio dentro del juego.
2. Detiene el servidor de forma segura (`stop`).
3. Crea un backup del directorio completo `~/minecraft` en `~/minecraft_backup.tar.gz` (sobrescribiendo el anterior si existe).
4. Intenta descargar la última versión del JAR de PaperMC para la misma versión de Minecraft que seleccionaste durante la instalación inicial.
5. Reinicia completamente el sistema operativo (`sudo reboot`).

Úsalo principalmente para los reinicios programados o cuando necesites una actualización simple y un reinicio completo del sistema. Para una actualización más controlada, consulta [Actualizar el Servidor](#actualizar-el-servidor).

### Acceder a la Consola del Servidor

Para ver la consola del servidor (donde ves los logs y puedes escribir comandos de Minecraft):

```sh
screen -r minecraft
```

Para salir de la consola y dejar el servidor corriendo en segundo plano, presiona `Ctrl + A` y luego `Ctrl + D`.

### Verificar si el Servidor está Activo

```sh
screen -ls
```

Si ves una línea que contiene `.minecraft` (ej. `12345.minecraft`), significa que la sesión de `screen` está activa y el servidor debería estar ejecutándose.

---

## Optimización del Servidor (Opcional)

El script de instalación descarga `optimize_server.sh`, que modifica varios archivos de configuración (`paper.yml`, `bukkit.yml`, `spigot.yml`, `server.properties`) con ajustes destinados a mejorar el rendimiento en dispositivos con recursos limitados como la Raspberry Pi.

### ¿Cuándo ejecutarlo?

Es recomendable ejecutarlo después de que el servidor haya arrancado al menos una vez (para que se generen los archivos de configuración por defecto) y antes de empezar a jugar de forma intensiva.

### ¿Cómo ejecutarlo?

```sh
cd ~/minecraft
./optimize_server.sh
```

Puedes revisar los cambios que realiza el script editándolo (`nano optimize_server.sh`) o revisando los archivos `.yml` y `.properties` después de ejecutarlo.

---

## Actualizar el Servidor

Hay dos formas principales de actualizar:

### Usando el Script de Instalación (Recomendado)

Este método te permite cambiar a una versión diferente de Minecraft si lo deseas.

1. Ejecuta de nuevo el script de instalación:

    ```sh
    cd ~
    ./SetupMinecraft.sh
    ```

2. Cuando te pregunte qué hacer porque el directorio `minecraft` ya existe, elige la opción `2) Actualizar/Mejorar`.

El script te permitirá seleccionar una nueva versión de Minecraft (o la misma para obtener el último build de PaperMC) y descargará el JAR correspondiente, manteniendo tus mundos y configuraciones (aunque siempre es bueno tener un backup).

### Usando `restart.sh` (Simple, Mantiene Versión)

Como se mencionó, `./restart.sh` intenta descargar el último build de PaperMC para la misma versión de Minecraft que instalaste originalmente y reinicia el sistema.

Es más simple pero menos flexible.

**¡Importante!** Antes de cualquier actualización mayor (ej. de 1.20 a 1.21), siempre haz un backup manual de tu carpeta `~/minecraft`.

---

## Gestionar el Servicio (Inicio Automático)

Si durante la instalación habilitaste el inicio automático, el servidor se gestiona a través de `systemd`. Puedes controlar el servicio con los siguientes comandos:

- **Habilitar inicio automático al arrancar:**

    ```sh
    sudo systemctl enable minecraft.service
    ```

- **Deshabilitar inicio automático al arrancar:**

    ```sh
    sudo systemctl disable minecraft.service
    ```

- **Iniciar el servicio manualmente:**

    ```sh
    sudo systemctl start minecraft.service
    ```

- **Detener el servicio manualmente:**

    ```sh
    sudo systemctl stop minecraft.service
    ```

- **Ver el estado del servicio:**

    ```sh
    sudo systemctl status minecraft.service
    ```

- **Ver los últimos logs del servicio:**

    ```sh
    journalctl -u minecraft.service -n 50 --no-pager
    ```

---

## Gestionar Reinicios Automáticos (Cron)

Si durante la instalación habilitaste los reinicios automáticos, se añadió una entrada a `crontab` para ejecutar `~/minecraft/restart.sh` diariamente a las 4 AM.

### Para editar, ver o eliminar esta tarea programada:

1. Abre el editor de `crontab`:

    ```sh
    crontab -e
    ```

2. Busca la línea que contiene `~/minecraft/restart.sh`.

3. Para cambiar la hora, modifica los primeros números (minuto y hora). Por ejemplo, `0 5 * * *` sería a las 5:00 AM.

4. Para deshabilitar el reinicio automático, añade un `#` al principio de la línea para comentarla o elimina la línea completa.

5. Guarda los cambios y cierra el editor (en `nano`, es `Ctrl+X`, luego `Y`, luego `Enter`).

---

## Notas Importantes

- **Port Forwarding:** Para que otros jugadores fuera de tu red local puedan conectarse, necesitas configurar el "Port Forwarding" (reenvío de puertos) en tu router. Debes redirigir el puerto TCP `25565` (o el que hayas configurado en `server.properties`) hacia la dirección IP local de tu Raspberry Pi / dispositivo ARM. El proceso varía según el router.

- **Backup:** El script `restart.sh` crea un backup, pero considera implementar una estrategia de backups más robusta si tu mundo es importante (ej. backups incrementales a un disco externo o almacenamiento en la nube).

- **Rendimiento:** PaperMC está optimizado, pero Minecraft sigue siendo exigente. El rendimiento dependerá de tu hardware, la versión de Minecraft, el número de jugadores y los plugins que uses. Ajustar la memoria RAM asignada (`start.sh`) y aplicar las optimizaciones (`optimize_server.sh`) puede ayudar.
