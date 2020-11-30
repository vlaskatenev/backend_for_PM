
Import-Module .\rest_api\config\Modules\14logsWrite

$pathToPowershell = "c:\windows\system32\windowspowershell\v1.0\powershell.exe"
$pathToWorkingscriptCli = "c:\setup\workingscript.cli"
$pathToWorkingscriptPs1 = "C:\Setup\workingscript.ps1"

function checkingProcessTask {

    # Усзнаем PID процесса. Сам скрипт (значение переменной fileMakedScript) находится в разных файлах (смотря где вызываются)
    $fileMakedScript | Out-File -Encoding UTF8 C:\Setup\$scriptname
    
    if ((Test-Path "C:\Setup\$scriptname") -eq 1) {

        start-process -filepath $pathToPowershell -argumentlist "-executionpolicy bypass -file c:\setup\$scriptname -windowstyle hidden"

    } else {

        logsWrite -programName $ProgrammName -fieldsinmainLog "script_id," -fields "11," -eventsId 15

    }

    while ((Test-Path "c:\setup\valuePID.cli") -eq 0) {
        
    Wait-Event -Timeout 4
    [int]$wait = $wait + 1
    
    if ($wait -eq 1) {

        logsWrite -programName $ProgrammName -fieldsinmainLog "script_id," -fields "11," -eventsId 41
    }

    if ($wait -eq 12) {
        
        [int]$wait = 1
        logsWrite -programName $ProgrammName -fieldsinmainLog "script_id," -fields "11," -eventsId 42
        # После поддтверждения запуск скрипта будет повторный и проверка работает скрипт или нет
        exit
      
    }
    }

    # применяем значение PID к переменной
    $processPID = Import-Clixml -Path "c:\setup\valuePID.cli"
    Remove-Item  "c:\setup\valuePID.cli" -Force
    
    # применяем переменные для цикла while который будет проверять работает ли процесс с нужным PID
    $workingScript = "`$filetemp = Get-CimInstance -Class Win32_Process -Filter  `"ProcessId = '$processPID'`"
                            [bool]`$haveproceccPID = `$filetemp.ProcessId -like $processPID
                        Export-Clixml -Path $pathToWorkingscriptCli -Encoding UTF8 -InputObject `$haveproceccPID"

    $workingScript | Out-File -Encoding UTF8 $pathToWorkingscriptPs1
    Start-Process -FilePath $pathToPowershell -ArgumentList "-ExecutionPolicy Bypass -File $pathToWorkingscriptPs1" -WindowStyle hidden
    [int]$wait = 1

    while ((Test-Path $pathToWorkingscriptCli) -eq 0) {
            
        Wait-Event -Timeout 4

    if ($wait -eq 1) {    
        logsWrite -programName $ProgrammName -fieldsinmainLog "script_id," -fields "11," -eventsId 41
    }

    if ($wait -eq 12) {
        [int]$wait = 1
        logsWrite -programName $ProgrammName -fieldsinmainLog "script_id," -fields "12," -eventsId 42
        # После 10 проверки будет перезапуск процесса который создает файл workingscript.cli
        exit
    }

    [int]$wait = $wait + 1

    }

    $workingscriptCLI = Import-Clixml -Path $pathToWorkingscriptCli
    Remove-Item  $pathToWorkingscriptCli -Force

    # зацикливаем поиск процесса пока он не завершится и перезапускаем скрипт для поиска процесса с нужным PID
    while ($workingscriptCLI) {

        Start-Process -FilePath $pathToPowershell -ArgumentList "-ExecutionPolicy Bypass -File $pathToWorkingscriptPs1" -WindowStyle hidden
        [int]$wait = 1
        while ((Test-Path $pathToWorkingscriptCli) -eq 0) {
            
            Wait-Event -Timeout 4
                
    if ($wait -eq 1) {    
        logsWrite -programName $ProgrammName -fieldsinmainLog "script_id," -fields "11," -eventsId 43
    }

    if ($wait -eq 12) {
        [int]$wait = 1
        logsWrite -programName $ProgrammName -fieldsinmainLog "script_id," -fields "11," -eventsId 44
        # После 10 проверки будет перезапуск процесса который создает файл workingscript.cli
        exit
    }

        [int]$wait = $wait + 1

    }

        $workingscriptCLI = Import-Clixml -Path $pathToWorkingscriptCli
        Remove-Item  $pathToWorkingscriptCli -Force
        Wait-Event -Timeout 4

}

# удаляем скрипты "проверки запуска процесса"
Remove-Item  $pathToWorkingscriptPs1 -Force
logsWrite -programName $ProgrammName -fieldsinmainLog "script_id," -fields "13," -eventsId 45

Remove-Item "c:\setup\$scriptname" -Force
logsWrite -programName $ProgrammName -fieldsinmainLog "script_id," -fields "14," -eventsId 45
}