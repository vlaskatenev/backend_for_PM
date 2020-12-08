# функция запускает установщик софта - просто загруженый 
function installExe { 
        # installExe -installExe $installExe -key $key
        Param (
            $installer,
            $key
        )
        Wait-Event -Timeout 15

        logsWrite -eventsId 25

        $processId = (Start-Process -FilePath "c:\Setup\$installer" -ArgumentList $key -WindowStyle hidden -passthru).Id

        return $processId
}


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
        # copyFile -url "http://dl.remouse.com/ReMouseMicro-Setup.exe"
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
                        Remove-Item $fileDelete -Recurse 
                        logsWrite -logString "$fileDelete file deleted"
                } Catch { logsWrite -logString "$fileDelete - problem this deleted file or folder" }
        } else { logsWrite -logString "$fileDelete no file" }
}


function newScheduledTaskTrigger {
        # newScheduledTaskTrigger -shortProgrammName $shortProgrammName
        Param (
                $shortProgrammName,
                $programmFile
                )
        $pathToPowershell = "c:\windows\system32\windowspowershell\v1.0\powershell.exe"
        $pathToWorkingscriptPs1 = "C:\Setup\workingscript.ps1"
        # Делаем скрипт для создания задания в планировщике заданий
        
        $taskScheduledTaskTrigger =  "`$Trigger= New-ScheduledTaskTrigger -AtStartup 
                                      `$User= `"NT AUTHORITY\SYSTEM`"
                                      `$Action= New-ScheduledTaskAction -Execute `"PowerShell.exe`" -Argument `"-ExecutionPolicy Bypass -File C:\Setup\StartupScript$ShortProgrammName.ps1`"
                                      Register-ScheduledTask -TaskName `"StartupScript$ShortProgrammName`" -Trigger `$Trigger -User `$User -Action `$Action -RunLevel Highest –Force"
        
        $taskScheduledTaskTrigger | Out-File -Encoding UTF8 $pathToWorkingscriptPs1
        Start-Process -FilePath $pathToPowershell -ArgumentList "-ExecutionPolicy Bypass -File $pathToWorkingscriptPs1" -WindowStyle hidden

        #####################################################################
        
        # Делаем скрипт который будет выполняться планировщиком заданий после перезагрузки ПК
        
        $MakeStartupScript = "  Remove-Item C:\Setup\$programmFile
                                Unregister-ScheduledTask -TaskName StartupScript$ShortProgrammName -Confirm:$false
                                Remove-Item C:\Setup\StartupScript$ShortProgrammName.ps1 -Force
                                Remove-Item $pathToWorkingscriptPs1 -Force"

        $MakeStartupScript | Out-File -Encoding UTF8 C:\Setup\StartupScript$ShortProgrammName.ps1
}

        