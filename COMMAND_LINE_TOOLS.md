# 🚀 Guía de Instalación: Android SDK Command Line Tools (Ubuntu)

Esta guía permite configurar un entorno de desarrollo para **Expo / React Native** sin necesidad de instalar Android Studio completo, ahorrando espacio y recursos de sistema.

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado el Java Development Kit (JDK). Para Expo, se recomienda la versión 17.

```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
```

## 🛠️ Paso 1: Descarga de Herramientas
Dirígete a la Web Oficial de Android.

Descarga el paquete de Command line tools only para Linux.

O usa la terminal:

```bash
cd ~/Downloads
wget [https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip](https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip)
```

## 📂 Paso 2: Estructura de Carpetas (Muy Importante)
Android requiere una estructura específica para reconocer las herramientas. Ejecuta estos comandos:

```bash
# Crear directorio del SDK
mkdir -p ~/Android/sdk/cmdline-tools

# Descomprimir el archivo descargado
unzip commandlinetools-linux-*.zip

# Mover el contenido a la subcarpeta 'latest'
mv cmdline-tools ~/Android/sdk/cmdline-tools/latest
``` 

Nota: La ruta final debe verse así: ~/Android/sdk/cmdline-tools/latest/bin/...

## 🌐 Paso 3: Variables de Entorno
Para que los comandos sean accesibles desde cualquier terminal, edita tu archivo .bashrc (o .zshrc si usas Zsh):

```bash
nano ~/.bashrc
```

Copia y pega lo siguiente al final del archivo:

```bash
# Android SDK
export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

# Java Home (Opcional pero recomendado)
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
```

Guarda los cambios (Ctrl+O, Enter, Ctrl+X) y aplica la configuración:

```bash
source ~/.bashrc
```

## 📦 Paso 4: Instalación de Componentes del SDK
Ahora instalaremos los binarios necesarios para compilar aplicaciones.

Aceptar Licencias:

```bash
sdkmanager --licenses
```
(Presiona y en todas las preguntas).

Instalar Plataforma y Build-Tools (Versión recomendada para Expo):

```bash
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

## ✅ Paso 5: Verificación
Para confirmar que todo está listo, ejecuta el doctor de Expo en tu proyecto:

```bash
npx expo doctor
```
Si todo es correcto, verás que el Android SDK está configurado y listo para usar sin haber instalado Android Studio.

Tip Pro: ADB inalámbrico, 

```bash
adb pair <IP>:<port-pair-code>
adb connect <IP>:<port> 
npx expo run:android
```


## Connect android phone

En powershell ejecutar:
```bash
 netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=8081 connectaddress=127.0.0.1 connectport=8081
 ```
Esto crea un tunel entre el host y wsl
