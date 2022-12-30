#===========================================================================
#  - Difnicion de Requerimientos
#       -Obtener todo el contenido de un JsonBackup(Completo: Registros de las 10 maquinas +/- 2)
#       -Crear un Reporte General de cada Ciclo completo de Backup.
#       -Borrar Imagenes en el Nas (Old Data).
#       -Desarrollar Interfaz (GUI).
#       -Crear un Moduls para Script Json.
#       -Informe de almacenamiento deL Nas por email.
#===========================================================================

#===========================================================================
#  - Acceso a las Carpetas-serv
#===========================================================================
$pathJsonLocal = "C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\Json"
$pathJsonServ = "\\192.168.0.101\grupos\Sistemas\Json-BackupPc\datos1.json"

$DatosJson = $pathJsonServ | ConvertTo-Json | ConvertFrom-Json
