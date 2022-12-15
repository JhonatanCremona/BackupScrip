# ---De esta forma me ubico en la ruta en donde se encuentra la Imagen.iso
# $rutaActual = Set-Location -Path "C:\Users\$nombreUser\Documents\ImagenBackup" -PassThru

#-----------VARIABLES GLOBALES--------------
$nombreUser = [System.Environment]::UserName

$urlLocal = "D:\ImagenBackup"
$pathNas = "\\192.168.0.101\grupos\Sistemas\Manuales\testing\$nombreUser"
$pathJson = "C:\Users\jfulguera\Documents\visualProyects\datos1.json"

#---------COMPROBAR EL ESPACIO DISPONIBLE DENTRO DEL DIRECTORIO LOCAL.-------

$ListaDirLocal = Get-ChildItem -Force $urlLocal -Directory -Recurse -ErrorAction SilentlyContinue | % { $_.fullName }
$respuesta = @()
foreach ($content in $ListaDirLocal) {

    $o= Get-ChildItem –force $content –Recurse -ErrorAction SilentlyContinue | measure Length -s -ErrorAction SilentlyContinue | Select-Object -Property @{name='Directorio';expression={$content}}, @{n="Size(GB)";e={[math]::Round((($_.Sum)/1GB),2)}}

    $respuesta+= $o
}
write-host $respuesta

$respuesta = Get-ChildItem -Force $urlLocal -Recurse -ErrorAction SilentlyContinue | measure length -s -ErrorAction SilentlyContinue | Select-Object -Property @{n="PESO";e={[math]::Round((($_.Sum)/1GB),2)}}
$respuesta.GetType().Name
[int]$respuesta.PESO
if ([int]$respuesta.PESO -gt 300) {
    Write-Warning "ADVERTENCIA! te estas quedando sin espacio"
    BorrarOldArchiveIso("")
} else {
    Write-Warning "Todavia queda espacio disponible"
}

function BorrarOldArchiveIso {
    param (
    )
    $fecha = Get-Childitem $urlLocal -Filter "*.*" |
                Where-Object {$_.LastWriteTime -lt (get-date).AddDays(-7) } |
                    Select-Object Name, LastWriteTime

    if ($fecha.values.count -gt 1) {
        Write-Host "Debes Borar el contenido"
        $fecha.GetType().Name
        foreach ($fech in $fecha) {
            write-host $fech.Name
            $dato = $fech.Name
            Write-Host $urlLocal$dato
            remove-item -Path $urlLocal$dato -WhatIf
        }
    } else {
        Write-Information "El directorio se encuentra estable de espacio libre"
    }
}

#--------------Configuracion: Filtro para obtener el archivo ISO(mas reciente)------
$dias = 2
$Time = (Get-Date).AddDays(-($dias))
$Time
#$result = Get-ChildItem -Path C:\Users\$nombreUser\Documents\ImagenBackup\ TEST.rar -Recurse -ErrorAction SilentlyContinue -Force | Where-Object { $.lastWriteTime -gt $Time }

#-------------Obtener el nombre del archivo----------------
$listaDir = Get-Childitem $urlLocal -Filter "*.*" |
                Where-Object {$_.LastWriteTime -gt (Get-Date -DisplayHint Date).AddDays(-1)} | 
                    % { $_.Name }
$listaDir[0]
$respuesta = @{}


$result = Get-ChildItem -Path $urlLocal $listaDir[0] -Recurse -ErrorAction SilentlyContinue -Force

#--------------Configuracion de Correo electronico-------------------
$usuario = "jfulguera@creminox.com"
$pass = "++++++"
[SecureString]$securepassword = $pass | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $usuario, $securepassword

#-----------------CREAR CARPETA DE USUARIO EN EL NAS------------------

if(!(test-path $pathNas))
{
      New-Item -ItemType Directory -Path $pathNas
      Write-Output "Se creo una carpeta con el nombre del usuarioLocal"
}
#Get-ChildItem -File -Recurse | Get-FileHash -Algorithm MD5 | Select-Object @{name="Name";expression={$_.Path}}, @{name="md5";expression={$_.Hash}} | ConvertTo-Json

$datosJson = Get-Content -Path $pathJson | ConvertFrom-Json
$datosJson[0].Nombre.Contains("jfulguera") 
function GenerarJson {
    param (
        
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

#----------------ENVIAR IMAGEN ISO AL NAS----------------------------
Write-Output "Proceso en marcha..."
if ($result) {
    $archivo = $listaDir[0]
    $archivo.GetType().Name
    Copy-Item -Path "$urlLocal\$archivo" -Destination $pathNas -Force

    #-----------ENVIAR CORREO 365 (CASO DE EXITO) -------------------
    #Send-MailMessage -SmtpServer smtp.office365.com -Port 587 -UseSsl -From jfulguera@creminox.com -To sistemas@creminox.com -Subject "Resultado Imagen Backup" -Body "En la maquina de $nombreUser se realizo el backup de Forma Exitosaa!😀" -Credential $credential
    
    $descripcion = "Tarea finalizada con Exito!"
    $estado = "True"
    GenerarJson("")

    Write-Output "Tarea finalizada con Exito!"
}else {
    #-----------ENVIAR CORREO 365 (CASO DE FALLO) -------------------
    #Send-MailMessage -SmtpServer smtp.office365.com -Port 587 -UseSsl -From jfulguera@creminox.com -To sistemas@creminox.com -Subject "Resultado Imagen Backup" -Body "Ocurrio un PROBLEMAA al crear la imagen en la maquina de $nombreUser !!!! 😨" -Credential $credential 

    $estado = "false"
    $descripcion = "No se encontro ninguna Imagen en la maquina del usuario"
    GenerarJson("")

    Write-Output "-----!Error--------"   
}
