Import-Module C:\Users\jhona\OneDrive\Documentos\ProyectShell\BackupScrip\email\mailModule.psm1

Send-MailKitMessage -From 'jfulguera@creminox.com' -To 'jhonatanful@outlook.es' -Body '<h1>Test</h1><h3>Test message</h3>' -BodyAsHtml -SMTPServer 'smtp-legacy.office365.com' -Port 587 -Credential $(Get-Credential)
function FunctionName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $SMTPServer
    )
    Write-Output "Verificando content: $SMTPServer"
    
}
FunctionName -SMTPServer 'smtp-legacy.office365.com'