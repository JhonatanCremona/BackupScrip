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
        [String]$Subject="",
        [Parameter()]
        [String]$Body = "",
        [Parameter()]
        $Attachments,
        [Parameter(Mandatory)]
        [String]$SMPTServer,
        [Parameter()]
        [int32]$Port = 25,
        [Parameter()]
        [switch]$BodyAsHtml,
        [Parameter()]
        $credenciales
    )
    $SMTP=New-Object MailKit.Net.Smtp.SmtpClient
    $Message=New-Object MimeKit.MimeMessage
    $Builder=New-Object MimeKit.BodyBuilder

    $Message.From.Add($From)

    foreach($Person in $To){
        $Message.To.Add($Person)
    }

    if($CC){
        foreach($Person in $CC){
            $Message.Cc.Add($Person)
        }
    }

    if($BCC){
        foreach($Person in $BCC){
            $Message.Bcc.Add($Person)
        }
    }

    $Message.Subject=$Subject

    if($BodyAsHtml){
        $Builder.HtmlBody=$Body
    }else{
        $Builder.TextBody=$Body
    }

    if($Attachments){
        foreach($Attachment in $Attachments){
            $Builder.Attachments.Add($Attachment)
        }
    }

    $Message.Body=$Builder.ToMessageBody()

    $SMTP.Connect($SMTPServer,$Port,$false)

    if($Credential){
        $SMTP.Authenticate($Credential.username,$Credential.getNetworkCredential().password)
    }

    $SMTP.Send($Message)

    $SMTP.Disconnect($true)
    $SMTP.Dispose()
}