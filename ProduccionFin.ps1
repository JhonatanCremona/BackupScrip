#$nombreUser = [System.Environment]::UserName
$nombreUser = "GuillermoNetbook"

$urlLocal = "G:\ImagenBackup"
$pathNas = "\\192.168.0.247\Virtuales\$nombreUser"
$pathJson = "\\192.168.0.101\grupos\Sistemas\Json-BackupPc\datos1.json"

$datosJson = Get-Content -Path $pathJson | ConvertFrom-Json
#-----------------CREAR CARPETA DE USUARIO EN EL NAS------------------

if(!(test-path $pathNas))
{
      New-Item -ItemType Directory -Path $pathNas
      Write-Output "Se creo una carpeta con el nombre del usuarioLocal"
}
#------------------METODOS--------------------
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
#--------------Configuracion de Correo electronico-------------------
$usuario = "jfulguera@creminox.com"
$pass = "Cremona.2022"
[SecureString]$securepassword = $pass | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $usuario, $securepassword

#-------------Obtener el nombre del archivo----------------
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

#$result = Get-ChildItem -Path $urlLocal $listaDir[0] -Recurse -ErrorAction SilentlyContinue -Force
$result = Get-ChildItem -Path "$urlLocal\$archivo" -Recurse -ErrorAction SilentlyContinue -Force

#----------------ENVIAR IMAGEN ISO AL NAS----------------------------
Write-Output "Proceso en marcha..."
if ($result) {
    
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
