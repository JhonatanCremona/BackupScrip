#===========================================================================
# Tab 1 - Install Moduls
#===========================================================================
Import-Module C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\email\mailModule.psm1
$Cuenta = Import-Clixml -Path C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\email\emailtest.xml

$nombreUser = [System.Environment]::UserName
#$nombreUser = "GuillermoNetbook"

<#
    $urlLocal = "G:\ImagenBackup"
    $pathNas = "\\192.168.0.247\Virtuales\$nombreUser"
    $pathJson = "\\192.168.0.101\grupos\Sistemas\Json-BackupPc\datos1.json"
#>
<#
    $urlLocal = "C:\Users\$nombreUser\OneDrive\Documentos\ProyectShell\BackupScrip\DiscoLocal-ImagenBackup"
    $pathNas = "C:\Users\$nombreUser\OneDrive\Documentos\ProyectShell\BackupScrip\Nas\$nombreUser"
    $pathJson = "C:\Users\$nombreUser\OneDrive\Documentos\ProyectShell\BackupScrip\Json\datos1.json"
#>
$urlLocal = "C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\DiscoLocal-ImagenBackup"
$pathNas = "C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\Nas\$nombreUser"
$pathJson= "C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\Json\datos1.json"

$datosJson = Get-Content -Path $pathJson | ConvertFrom-Json
#===========================================================================
# CREAR CARPETA DE USUARIO EN EL NAS-
#===========================================================================

if(!(test-path $pathNas))
{
      New-Item -ItemType Directory -Path $pathNas
      Write-Output "Se creo una carpeta con el nombre del usuarioLocal"
}
#------------------METODOS--------------------
function GenerarJson {
    param (
        [Parameter(Mandatory)]
        [string]$descripcion,
        [Parameter(Mandatory)]
        [string]$estado
    )
    $cantidad = 0
    for ($i = 0; $i -lt $datosJson.values.Count; $i++) {
        $dato = $datosJson[$i].Nombre.Contains($nombreUser)
        if (!$dato) {
            $cantidad = $cantidad + 1;
        }
    }
    if ($cantidad -eq $datosJson.values.Count) {
        Write-Output "No existe este usuario"
        $Json =  @()
        $Json += $datosJson

        $info = "" | Select userId,Nombre,Resultado,estado,Fecha
        $info.userId = $datosJson.values.Count + 1
        $info.Nombre = $nombreUser
        $info.Resultado = $descripcion
        $info.estado = $estado
        $info.Fecha = Get-Date -Format "dddd MM/dd/yyyy HH:mm"

        $Json += $info
        $Json | ConvertTo-Json | Out-File -FilePath $pathJson

    } else {
        Write-Output "Existe este usuario"
    }    
}

#===========================================================================
#  - Obtener el nombre del archivo
#===========================================================================

$listaDir = Get-Childitem $urlLocal -Filter "*.*" |
                Where-Object {$_.LastWriteTime -gt (Get-Date -DisplayHint Date).AddDays(-4)} | 
                    % { $_.Name }
$listaDir.GetType().Name

$respuesta = $listaDir.count -gt 1
if ( $respuesta ) {
    Write-Warning "Tenemos un objeto"
    $archivo = $listaDir[0]
}else {
    Write-Output "Tenemos un String"
    $archivo = $listaDir
}


$result = Get-ChildItem -Path "$urlLocal\$archivo" -Recurse -ErrorAction SilentlyContinue -Force

#===========================================================================
# Tab 2 - ENVIAR IMAGEN ISO AL NAS
#===========================================================================

Write-Output "Proceso en marcha..."

foreach ($lista in $listaDir) {
    Write-Host $lista + "error"
    Robocopy C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\DiscoLocal-ImagenBackup C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\Nas\jfulguera /E /Z /ZB /R:5 /TBD /NP /V /XF "C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\DiscoLocal-ImagenBackup\$lista"
}


if ($result) {
    
    #Copy-Item -Path "$urlLocal\$archivo" -Destination $pathNas -Force
    Robocopy "C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\DiscoLocal-ImagenBackup" "C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\Nas\jfulguera" $archivo /z /j /copy:D
    GenerarJson -descripcion "Tarea finalizada con Exito!" -estado "true"

    Write-Output "Tarea finalizada con Exito!"
}else {

    GenerarJson -descripcion "No se encontro ninguna Imagen en la maquina del usuario" -estado "false"

    Write-Output "-----!Error--------"   
}

#===========================================================================
# Tab 2 - Configuracion de Correo electronico
#===========================================================================

if ($datosJson.values.count -gt 8) {
    $Parametros = @{
        From = "jfulguera@creminox.com"
        To = @("jhonatanful@outlook.es", "sistemas@creminox.com")
        Subject = "Diagnostico ImagenBackup-Pc Cremona"
        Body = "<h1>Resultado</h1> <p>Descripcion prueba en el archivo adjunto</p>"
        Attachments = @("C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\Json\datos1.json", "C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\Json\datos1.json")
        SMTPServer = 'smtp-legacy.office365.com'
        Port = 587
        Credential = $Cuenta
        BodyAsHtml = $true
    }
    Send-MailKitMessage @Parametros
}