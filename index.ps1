# ---De esta forma me ubico en la ruta en donde se encuentra la Imagen.iso
# $rutaActual = Set-Location -Path "C:\Users\$nombreUser\Documents\ImagenBackup" -PassThru

#-----------VARIABLES GLOBALES--------------
$nombreUser = [System.Environment]::UserName

#--------------Configuracion: Filtro para obtener el archivo ISO(mas reciente)------
$dias = 2
$Time = (Get-Date).AddDays(-($dias))
$Time
#$result = Get-ChildItem -Path C:\Users\$nombreUser\Documents\ImagenBackup\ TEST.rar -Recurse -ErrorAction SilentlyContinue -Force | Where-Object { $.lastWriteTime -gt $Time }

$result = Get-ChildItem -Path C:\Users\$nombreUser\Documents\ImagenBackup\ TEST2.rar -Recurse -ErrorAction SilentlyContinue -Force

#--------------Configuracion de Correo electronico-------------------
$usuario = "jfulguera@creminox.com"
$pass = "Cremona.2022"
[SecureString]$securepassword = $pass | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $usuario, $securepassword




#-----------------CREAR CARPETA DE USUARIO EN EL NAS------------------
$pathNas = "\\192.168.0.101\grupos\Sistemas\Manuales\testing\$nombreUser"

if(!(test-path $pathNas))
{
      New-Item -ItemType Directory -Path $pathNas
      Write-Output "Se creo una carpeta con el nombre del usuarioLocal"
}
#Get-ChildItem -File -Recurse | Get-FileHash -Algorithm MD5 | Select-Object @{name="Name";expression={$_.Path}}, @{name="md5";expression={$_.Hash}} | ConvertTo-Json
$URL = "C:\Users\jfulguera\Documents\visualProyects\datos1.json"
$datosJson = Get-Content -Path $URL | ConvertFrom-Json
$datosJson 
function GenerarJson {
    param (
        
    )
    $Json =  @()
        $Json += $datosJson

        $info = "" | Select userId,Nombre,Resultado,estado,Fecha
        $info.userId = "2"
        $info.Nombre = $nombreUser
        $info.Resultado = $descripcion
        $info.estado = $estado
        $info.Fecha = Get-Date -Format "dddd MM/dd/yyyy HH:mm"

        $Json += $info
        $Json | ConvertTo-Json | Out-File -FilePath "C:\Users\jfulguera\Documents\visualProyects\datos1.json"
}


#----------------ENVIAR IMAGEN ISO AL NAS----------------------------
Write-Output "Proceso en marcha..."
if ($result) {
    Copy-Item -Path C:\Users\$nombreUser\Documents\ImagenBackup\Imagen1.txt -Destination \\192.168.0.101\grupos\Sistemas\Manuales\testing\$nombreUser -Force
    
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

Write-Host $result
