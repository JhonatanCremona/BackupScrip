# Backup con Reflect y Powershell

_Este script tiene la funcionalidad de transferir una imagen.iso de una Pc a un servidor ( Nas ). Ademas este genera un reporte del proceso, exporta un archivo Json, que luego sera adjuntado en un mensaje de Correo._

![screen-install](screen-install.png)

## Comenzando 🚀

### Pre-requisitos 📋

_Instalar en windows PowerShell 7_
   <a id="https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3" />descargar text

_Descargar Reflect._
  -Se encuentra en el server

### Instalación 🔧

- Desactivar windows Defenders
  - presionar las teclas de windows + r
  - Escribir "explorer.exe windowsdefender:" y luego presionar el boton aceptar
- Descargar Moduls
  
  _Instalar Moduls MimeKit_
    ```
    Install-Package -Name 'MimeKit' -Source "https://www.nuget.org/api/v2" -SkipDependencies
    ```
  _Instalar Moduls MailKit_
    ```
    Install-Package -Name 'MailKit' -Source "https://www.nuget.org/api/v2"
    ```
  
  - Descargar el archivo "ProduccionFin.ps1"
- Descargar proyecto completo
  - abrir gitBash (es Necesario tener instalado GitBash)
     <a id="https://gitforwindows.org/" />GitDownload text

    _inicializar proyecto git_

    ```
    git init
    git config user.name "Usuario"
    git config user.email jfulguera@creminox.com
    ```
    _Clonar repo Git_
    ```
    git clone "https://github.com/JhonatanCremona/BackupScrip.git"
    ```
- Configuracion en el Programador de tareas

  _Ejecutar la aplicacion con powershell 7_
    ```
    pwsh.exe
    ```
  _Agregar argumentos (obligatorio)_
    ```
    -NoProfile -NonInteractive -ExecutionPolicy Unrestricted -Command "& ruta al script a ejecutar"
    ```
- Updates
  - version 1.2v

