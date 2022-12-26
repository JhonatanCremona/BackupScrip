Install-Package -Name 'MimeKit' -Source "https://www.nuget.org/api/v2" -SkipDependencies
Install-Package -Name 'MailKit' -Source "https://www.nuget.org/api/v2"

Add-Type -Path "C:\Program Files\PackageManagement\NuGet\Packages\MailKit.3.4.3\lib\netstandard2.0\MailKit.dll"
Add-Type -Path "C:\Program Files\PackageManagement\NuGet\Packages\MimeKit.3.4.3\lib\netstandard2.0\MimeKit.dll"

#-----------------Con este comando encriptamos la contraseña del usuario--------------
#Get-Credential | Export-Clixml -Path C:\Users\jhona\OneDrive\Documentos\ProyectShell\BackupScrip\email\email.xml


$SMTP = New-Object MailKit.Net.Smtp.SmtpClient
$Message = New-Object MimeKit.MimeMessage
$Builder = New-Object MimeKit.BodyBuilder

$Account = Import-Clixml -Path C:\Users\jhona\OneDrive\Documentos\ProyectShell\BackupScrip\email\email.xml
$MyCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Account.UserName $Account.Password
 

$Message.From.add("jfulguera@creminox.com")
$Message.to.Add("jhonatanful@outlook.es")
$Message.Subject = "Test Message"
$Builder.TextBody = "Mensaje de prueba"
$Message.Body = $builder.ToMessageBody()
$SMTP.Connect("smtp.office365.com",587,$false)
$SMTP.Authenticate($Account)