#----------------------Desactivar deffenders------------------------------
Install-Package -Name 'MimeKit' -Source "https://www.nuget.org/api/v2" -SkipDependencies
Install-Package -Name 'MailKit' -Source "https://www.nuget.org/api/v2"

#----------------Este modulo solo funciona si se ejecuta con PówerShell 7-----------------------------
Add-Type -Path "C:\Program Files\PackageManagement\NuGet\Packages\MimeKit.3.4.3\lib\netstandard2.0\MimeKit.dll"
Add-Type -Path "C:\Program Files\PackageManagement\NuGet\Packages\MailKit.3.4.3\lib\netstandard2.0\MailKit.dll"


#-----------------Con este comando encriptamos la contraseña del usuario--------------
#Get-Credential | Export-Clixml -Path C:\Users\jhona\OneDrive\Documentos\ProyectShell\BackupScrip\email\email.xml
#Get-Credential | Export-Clixml -Path C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\email\emailtest.xml

$SMTP = New-Object MailKit.Net.Smtp.SmtpClient
$Message = New-Object MimeKit.MimeMessage
$Builder = New-Object MimeKit.BodyBuilder

$Account = Import-Clixml -Path C:\Users\jhona\OneDrive\Documentos\ProyectShell\BackupScrip\email\email.xml
#$Account = Import-Clixml -Path C:\Users\jfulguera\Desktop\ProyectScript\BackupScrip\email\emailtest.xml

$Message.From.add("jfulguera@creminox.com")
$Message.to.Add("jhonatanful@outlook.es")
$Message.Subject = "Test Message"
$Builder.TextBody = "Mensaje de prueba"
$Message.Body = $builder.ToMessageBody()
$SMTP.Connect("smtp.office365.com",587,$false)
$SMTP.Authenticate($Account)
$SMTP.Send($Message)
$SMTP.Disconnect($true)
$SMTP.Dispose()
