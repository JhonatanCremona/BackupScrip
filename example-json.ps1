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

function Copy-WithProgress {
    [CmdletBinding()]
    param (
            [Parameter(Mandatory = $true)]
            [string] $Source
        , [Parameter(Mandatory = $true)]
            [string] $Destination
        , [int] $Gap = 200
        , [int] $ReportGap = 2000
    )
    # Define regular expression that will gather number of bytes copied
    $RegexBytes = '(?<=\s+)\d+(?=\s+)';

    #region Robocopy params
    # MIR = Mirror mode
    # NP  = Don't show progress percentage in log
    # NC  = Don't log file classes (existing, new file, etc.)
    # BYTES = Show file sizes in bytes
    # NJH = Do not display robocopy job header (JH)
    # NJS = Do not display robocopy job summary (JS)
    # TEE = Display log in stdout AND in target log file
    $CommonRobocopyParams = '/MIR /NP /NDL /NC /BYTES /NJH /NJS';
    #endregion Robocopy params

    #region Robocopy Staging
    Write-Verbose -Message 'Analyzing robocopy job ...';
    $StagingLogPath = '{0}\temp\{1} robocopy staging.log' -f $env:windir, (Get-Date -Format 'yyyy-MM-dd HH-mm-ss');

    $StagingArgumentList = '"{0}" "{1}" /LOG:"{2}" /L {3}' -f $Source, $Destination, $StagingLogPath, $CommonRobocopyParams;
    Write-Verbose -Message ('Staging arguments: {0}' -f $StagingArgumentList);
    Start-Process -Wait -FilePath robocopy.exe -ArgumentList $StagingArgumentList -NoNewWindow;
    # Get the total number of files that will be copied
    $StagingContent = Get-Content -Path $StagingLogPath;
    $TotalFileCount = $StagingContent.Count - 1;

    # Get the total number of bytes to be copied
    [RegEx]::Matches(($StagingContent -join "`n"), $RegexBytes) | % { $BytesTotal = 0; } { $BytesTotal += $_.Value; };
    Write-Verbose -Message ('Total bytes to be copied: {0}' -f $BytesTotal);
    #endregion Robocopy Staging

    #region Start Robocopy
    # Begin the robocopy process
    $RobocopyLogPath = '{0}\temp\{1} robocopy.log' -f $env:windir, (Get-Date -Format 'yyyy-MM-dd HH-mm-ss');
    $ArgumentList = '"{0}" "{1}" /LOG:"{2}" /ipg:{3} {4}' -f $Source, $Destination, $RobocopyLogPath, $Gap, $CommonRobocopyParams;
    Write-Verbose -Message ('Beginning the robocopy process with arguments: {0}' -f $ArgumentList);
    $Robocopy = Start-Process -FilePath robocopy.exe -ArgumentList $ArgumentList -Verbose -PassThru -NoNewWindow;
    Start-Sleep -Milliseconds 100;
    #endregion Start Robocopy

    #region Progress bar loop
    while (!$Robocopy.HasExited) {
        Start-Sleep -Milliseconds $ReportGap;
        $BytesCopied = 0;
        $LogContent = Get-Content -Path $RobocopyLogPath;
        $BytesCopied = [Regex]::Matches($LogContent, $RegexBytes) | ForEach-Object -Process { $BytesCopied += $_.Value; } -End { $BytesCopied; };
        $CopiedFileCount = $LogContent.Count - 1;
        Write-Verbose -Message ('Bytes copied: {0}' -f $BytesCopied);
        Write-Verbose -Message ('Files copied: {0}' -f $LogContent.Count);
        $Percentage = 0;
        if ($BytesCopied -gt 0) {
           $Percentage = (($BytesCopied/$BytesTotal)*100)
        }
        Write-Progress -Activity Robocopy -Status ("Copied {0} of {1} files; Copied {2} of {3} bytes" -f $CopiedFileCount, $TotalFileCount, $BytesCopied, $BytesTotal) -PercentComplete $Percentage
    }
    #endregion Progress loop

    #region Function output
    [PSCustomObject]@{
        BytesCopied = $BytesCopied;
        FilesCopied = $CopiedFileCount;
    };
    #endregion Function output
}