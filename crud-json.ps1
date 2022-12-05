# CREAR CARPETA EN NASS
# Borrar Imagenes del Nas -(Filtro de antiguedad - Fecha).

$nombreUser = [System.Environment]::UserName

$meses = 1
$Time = (Get-Date).AddMonths(-($meses))
Write-Host $Time

$URL = "C:\Users\$nombreUser\Documents\ImagenBackup\TEST.rar"
$result = Get-ChildItem -Path C:\Users\$nombreUser\Documents\ImagenBackup\ -Filter *.* -Recurse -ErrorAction SilentlyContinue -Force | Where-Object { $_.lastWriteTime -gt $Time }
Write-Host $result

Get-ChildItem -Path C:\Users\$nombreUser\Documents\ImagenBackup\ -Filter *.* -Recurse -ErrorAction SilentlyContinue -Force | Where-Object CreationTime -LT (Get-Date).AddDays(-10)

if ($result) {
        Write-Output "Listo para borrar el archivo"
        Remove-Item $URL
    }else {echo "No encontre nada"}

New-Item -Path $URL
