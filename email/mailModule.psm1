Install-Package -Name 'MimeKit' -Source "https://www.nuget.org/api/v2" -SkipDependencies
Install-Package -Name 'MailKit' -Source "https://www.nuget.org/api/v2"

function Send-MailKitMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mendatory)]
        [String]$From,
        [Parameter(Mendatory)]
        $To,
        [Parameter()]
        $CC, 
        [Parameter()]
        $BCC,
        [Parameter()]
        


    )
    
}