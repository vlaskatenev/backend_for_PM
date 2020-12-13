# пишем в лог
function logsWrite {
    Param (
    [string]$fieldsinmainLog,
    [string]$fields,
    $logString=$False,
    [int]$eventsId,
    $softDisplayName="none"
    )
    $curDate = Get-Date
    if ($logString) {
            Write-Output "$curDate, $logString" >> C:\Setup\logInstall.txt
    } else {
            Write-Output "$curDate, programName $softDisplayName, $fieldsinmainLog $fields events_id $eventsId" >> C:\Setup\logInstall.txt
    }
}


function copyFile {
        # copyFile -url "http://dl.remouse.com/ReMouseMicro-Setup.exe" -file $file
        Param (
            $url,
            $file
        )
        $pathToDownload = "C:\Setup"
        if (-Not (Test-Path $pathToDownload)) { 
                New-Item  $pathToDownload
                logsWrite -logString "$pathToDownload maked"
         }
        Invoke-WebRequest -URI $url -outfile "$pathToDownload\$file"
        # Start-BitsTransfer –source  $url -destination $pathToDownload -Priority low
        logsWrite -logString "$url downloaded to $pathToDownload"
        return $true
}

function removeFile {
        Param (
                $fileDelete
                )
        
        if (Test-Path -Path $fileDelete) {
                Try {
                        Remove-Item -Path $fileDelete -Recurse -Force
                        logsWrite -logString "$fileDelete file deleted"
                } Catch { logsWrite -logString "$fileDelete - problem this deleted file or folder" }
        } else { logsWrite -logString "$fileDelete no file" }
}

$pathScript = "C:\Setup\installSoftScripts"

# загрузка основного архива и распаковка
$url="http://192.168.10.1:8081/scripts/installSoftScripts.zip"
$pathToDownload = "C:\Setup\installSoftScripts.zip"

if (Test-Path -Path $pathScript) {
    removeFile -fileDelete $pathScript
}

copyFile -url $url -file "installSoftScripts.zip"
Expand-Archive $pathToDownload -DestinationPath C:\Setup\
removeFile -fileDelete $pathToDownload

# загрузка скрипта со списком программ и ключами для установки
$compname = (Get-WmiObject -Class Win32_ComputerSystem).Name
$url = "http://192.168.10.1:8081/scripts/forClients/$compname.ps1"
$pathToDownload = "C:\Setup\installSoftScripts\programmVariables.ps1"
Invoke-WebRequest -URI $url -outfile $pathToDownload

Set-Location -Path C:\Setup\installSoftScripts
Start-Process -FilePath powershell -ArgumentList "-ExecutionPolicy Bypass -File C:\Setup\installSoftScripts\_startInstall.ps1" -WindowStyle hidden

Stop-Process -ID $PID -Force
