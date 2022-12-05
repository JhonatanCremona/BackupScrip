# CREAR CARPETA EN NASS
# Borrar Imagenes del Nas -(Filtro de antiguedad - Fecha).

$nombreUser = [System.Environment]::UserName

$meses = 1
$Time = (Get-Date).AddMonths(-($meses))
Write-Host $Time
$fecha = "12112022"

$URL = "C:\Users\$nombreUser\Documents\ImagenBackup\TEST$fecha.rar"
$result = Get-ChildItem -Path C:\Users\$nombreUser\Documents\ImagenBackup\ -Filter *.* -Recurse -ErrorAction SilentlyContinue -Force | Where-Object { $_.lastWriteTime -gt $Time }
Write-Host $result

#Get-ChildItem -Path C:\Users\$nombreUser\Documents\ImagenBackup\ -Filter *.* -Recurse -ErrorAction SilentlyContinue -Force | Where-Object CreationTime -LT (Get-Date).AddDays(-11)

if ($result) {
        Write-Output "Listo para borrar el archivo"
        Remove-Item $URL
    }else {echo "No encontre nada"}

New-Item -Path $URL

#-----------------CREAR CARPETA DE USUARIO EN EL NAS------------------
$path = "\\192.168.0.101\grupos\Sistemas\Manuales\testing\$nombreUser"

if(!(test-path $path))
{
      New-Item -ItemType Directory -Path $path
      Write-Output "Se creo una carpeta con el nombre del usuarioLocal"
}
function ConfigurarEntorno {
    param (
        $path
    )
        $path = "\\192.168.0.101\grupos\Sistemas\Manuales\testing\$nombreUser"

        if(!(test-path $path)){
            New-Item -ItemType Directory -Path $path
            Write-Output "Se creo una carpeta con el nombre del usuarioLocal"
        }
}

ConfigurarEntorno($path)