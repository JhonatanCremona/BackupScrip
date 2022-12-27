Import-Module C:\Users\jhona\OneDrive\Documentos\ProyectShell\BackupScrip\email\mailModule.psm1
#------------------------Se ejecuta unicamente powershell7--------------------------------
#Send-MailKitMessage -From 'jfulguera@creminox.com' -To 'jhonatanful@outlook.es' -Body '<h1>Test</h1><h3>Test message</h3>' -BodyAsHtml -SMTPServer 'smtp-legacy.office365.com' -Port 587 -Credential $(Get-Credential)

$Account = Import-Clixml -Path C:\Users\jhona\OneDrive\Documentos\ProyectShell\BackupScrip\email\email.xml
Send-MailKitMessage -From 'jfulguera@creminox.com' -To @("jhonatanful@outlook.es", "jhonatanfulgueralucana@gmail.com") -Body '<h1>Test message</h1>' -BodyAsHtml -Attachments @("C:\Users\jhona\OneDrive\Documentos\ProyectShell\BackupScrip\Json\datos1.json") -SMTPServer 'smtp-legacy.office365.com' -Port 587 -Credential $Account

function FunctionName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $SMTPServer
    )
    Write-Output "Verificando content: $SMTPServer"
    
}
FunctionName -SMTPServer 'smtp-legacy.office365.com'