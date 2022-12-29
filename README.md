# Backup con Reflect y Powershell

_Con este script puedes transladar una imagen.ISO a un servidor ( NAS ) Y LUEGO CREAR UN documento JSON --> En forma de reporte. Para que este sea compartido y enviado al admin de sistemas IT, atraves de mensaje de correo_

![screen-install](screen-install.png)

## Comenzando 🚀

_Descargar Reflect._

Mira **Deployment** para conocer como desplegar el proyecto.


### Pre-requisitos 📋

_Instalar en windows PowerShell 7_

### Instalación 🔧

- Desactivar windows Defenders
  - presionar las teclas de windows + r
  - Escribir "explorer.exe windowsdefender:" y luego presionar el boton aceptar
- Descargar
  _Instalar Moduls MimeKit_
    ```
    Install-Package -Name 'MimeKit' -Source "https://www.nuget.org/api/v2" -SkipDependencies
    ```
  _Instalar Moduls MailKit_
    ```
    Install-Package -Name 'MailKit' -Source "https://www.nuget.org/api/v2"
    ```
  
  - Descargar el archivo "ProduccionFin.ps1"
  - Has recommended settings for each type of system
- Descargar proyecto completo
  - abrir gitBash
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
- Updates
  - Fixes the default windows update scheme

