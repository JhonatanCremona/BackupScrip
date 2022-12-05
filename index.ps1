# ---De esta forma me ubico en la ruta en donde se encuentra la Imagen.iso
# $rutaActual = Set-Location -Path "C:\Users\$nombreUser\Documents\ImagenBackup" -PassThru

# ------------GUARDAMOS LA IMAGEN ISO EN EL SERVIDOR-----------

#-----------VARIABLES GLOBALES--------------
$nombreUser = [System.Environment]::UserName


#--------------Configuracion: Filtro para obtener el archivo ISO(mas reciente)------
$dias = 2
$Time = (Get-Date).AddDays(-($dias))
#$result = Get-ChildItem -Path C:\Users\$nombreUser\Documents\ImagenBackup\ TEST.rar -Recurse -ErrorAction SilentlyContinue -Force | Where-Object { $.lastWriteTime -gt $Time }

$result = Get-ChildItem -Path C:\Users\$nombreUser\Documents\ImagenBackup\ TEST.rar -Recurse -ErrorAction SilentlyContinue -Force

#--------------Configuracion de Correo electronico-------------------
$usuario = "jfulguera@creminox.com"
$pass = "Cremona.2022"
[SecureString]$securepassword = $pass | ConvertTo-SecureString -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $usuario, $securepassword




#-----------------CREAR CARPETA DE USUARIO EN EL NAS------------------
$path = "\\192.168.0.101\grupos\Sistemas\Manuales\testing\$nombreUser"

if(!(test-path $path))
{
      New-Item -ItemType Directory -Path $path
      Write-Output "Se creo una carpeta con el nombre del usuarioLocal"
}
#Get-ChildItem -File -Recurse | Get-FileHash -Algorithm MD5 | Select-Object @{name="Name";expression={$_.Path}}, @{name="md5";expression={$_.Hash}} | ConvertTo-Json
function GenerarJson {
    param (
        [string]$descripcion,[String]$estado
    )
    Write-Host $descripcion
    Write-Host $estado
    $testObject = New-Object -TypeName PSCustomObject
    Add-Member -InputObject $testObject -MemberType NoteProperty -Name "userId" -Value 105
    Add-Member -InputObject $testObject -MemberType NoteProperty -Name "nombre" -Value $nombreUser
    Add-Member -InputObject $testObject -MemberType NoteProperty -Name "Mensajes" -Value $descripcion
    Add-Member -InputObject $testObject -MemberType NoteProperty -Name "estado" -Value $estado

    $jsondata = $testObject | ConvertTo-Json | Out-File "C:\Users\jfulguera\Documents\ImagenBackup\export2.json"

    Write-Host $jsondata

}







#----------------ENVIAR IMAGEN ISO AL NAS----------------------------
if ($result) {
    Write-Output "Proceso en marcha..."
    Copy-Item -Path C:\Users\$nombreUser\Documents\ImagenBackup\Imagen1.txt -Destination \\192.168.0.101\grupos\Sistemas\Manuales\testing\$nombreUser -Force
    
    #-----------ENVIAR CORREO 365 (CASO DE EXITO) -------------------
    #Send-MailMessage -SmtpServer smtp.office365.com -Port 587 -UseSsl -From jfulguera@creminox.com -To sistemas@creminox.com -Subject "Resultado Imagen Backup" -Body "En la maquina de $nombreUser se realizo el backup de Forma Exitosaa!😀" -Credential $credential
    
    $descripcion = "Tarea finalizada con Exito!"
    $estado = "true"

    GenerarJson($descripcion, $estado)
    Write-Output "Tarea finalizada con Exito!"
}else {
    Write-Output "Proceso en marcha..."

    #-----------ENVIAR CORREO 365 (CASO DE FALLO) -------------------
    #Send-MailMessage -SmtpServer smtp.office365.com -Port 587 -UseSsl -From jfulguera@creminox.com -To sistemas@creminox.com -Subject "Resultado Imagen Backup" -Body "Ocurrio un PROBLEMAA al crear la imagen en la maquina de $nombreUser !!!! 😨" -Credential $credential 

    $estado = "false"
    $descripcion = "Fallaste"
    GenerarJson($descripcion, $estado)
    Write-Output "Error 😨😭😨"
    
}

Write-Host $result
