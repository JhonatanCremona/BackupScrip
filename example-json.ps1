#$JsonFilePath = "F:\ProyectoBackup\datos.json"
$JsonFilePathCrem = "C:\Users\jfulguera\Documents\visualProyects\datos.json"
$JsonData = Get-Content -Path $JsonFilePathCrem | ConvertFrom-Json

$employeeData = $JsonData.Maquinas

$employeeData | Where-Object nombre -eq "Pepito Conejo"

#------------Ejemplo de como crear una estructura json--------------

$JsonBody = @"
{
    "userId": "103",
    "nombre":"Jfulguera",
    "Maquinas": 99
}
"@

$JsonBody | ConvertFrom-Json

#------------Ejemplo de como crear una estructura json 2------------


$testObject = New-Object -TypeName PSCustomObject
Add-Member -InputObject $testObject -MemberType NoteProperty -Name "userId" -Value 105
Add-Member -InputObject $testObject -MemberType NoteProperty -Name "nombre" -Value "frusso"

$testObject | ConvertTo-Json

#------------------------------Unificar datos Json--------------------------------------
$JsonFilePathCrem = "C:\Users\jfulguera\Documents\visualProyects\datos.json"

$userLocal = [System.Environment]::UserName

$pruebaType = New-Object -TypeName PSCustomObject

$testing = Get-Content -Path $JsonFilePathCrem | ConvertFrom-Json

$testing | Add-Member -Name "nombre" -MemberType NoteProperty -Value $userLocal
#$JSON | ConvertTo-JSON | Out-File "D:\computer.json"<

<#--------------------Sobreescribimos el contenido del objeto Json--------------------#>

$testing | ConvertTo-Json | Out-File $JsonFilePathCrem

$MensajeErrorSoft = "No se creo la imagen dentro del equipo"
$MenesajeError = "Se interrumpio el proceso de carga"
$MensajeExito = "Se completo el proceso de Forma exitosa"

$user = "jhona"

$JsonBodyTest = @"
{
    "userId": "100",
    "nombre": "",
    "Maquinas": 99
}
"@
$JsonBodyTest | ConvertTo-Json | ConvertFrom-Json

$JsonBodyTest
