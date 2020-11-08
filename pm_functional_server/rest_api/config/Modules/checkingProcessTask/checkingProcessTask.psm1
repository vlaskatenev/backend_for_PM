
function checkingProcessTask {

    Import-Module .\rest_api\config\Modules\14MySQLout

    # Усзнаем PID процесса. Сам скрипт (значение переменной fileMakedScript) находится в разных файлах (смотря где вызываются)
    $fileMakedScript | Out-File -Encoding UTF8 \\$ipaddressHost\C$\Setup\$scriptname
    
    if ((Test-Path "\\$ipaddressHost\C$\Setup\$scriptname") -eq 1) {

        Start-Process -FilePath .\rest_api\config\bin\PsExec.exe -ArgumentList "\\$ipaddressHost powershell -ExecutionPolicy Bypass -File C:\Setup\$scriptname" -WindowStyle hidden

    } else {

        $global:fieldsinmain_log = "script_id,"
        $global:fields = "11,"
        $global:events_id = "15"
        MySQLWrite

    }

    while ((Test-Path "\\$ipaddressHost\C$\Setup\valuePID.cli") -eq 0) {
        
    Wait-Event -Timeout 4
    [int]$wait = $wait + 1
    
    if ($wait -eq 1) {    
        
        $global:fieldsinmain_log = "script_id,"
        $global:fields = "11,"
        $global:events_id = "41"
        MySQLWrite
    }

    if ($wait -eq 12) {
        
        [int]$wait = 1
        $global:fieldsinmain_log = "script_id,"
        $global:fields = "11,"
        $global:events_id = "42"
        MySQLWrite
        # После поддтверждения запуск скрипта будет повторный и проверка работает скрипт или нет
        exit
      
    }
    }

    # применяем значение PID к переменной
    $global:ProcessPID = Import-Clixml -Path "\\$ipaddressHost\C$\Setup\valuePID.cli"
    Remove-Item  "\\$ipaddressHost\C$\Setup\valuePID.cli" -Force
    
    # применяем переменные для цикла while который будет проверять работает ли процесс с нужным PID
    $global:workingscript = "`$filetemp = Get-CimInstance -Class Win32_Process -Filter  `"ProcessId = '$ProcessPID'`"
                            [bool]`$haveproceccPID = `$filetemp.ProcessId -like $ProcessPID
                        Export-Clixml -Path `C:\setup\workingscript.cli -Encoding UTF8 -InputObject `$haveproceccPID"

    $global:workingscript | Out-File -Encoding UTF8 \\$ipaddressHost\C$\Setup\workingscript.ps1
    Start-Process -FilePath .\rest_api\config\bin\PsExec.exe -ArgumentList "\\$ipaddressHost powershell -ExecutionPolicy Bypass -File C:\Setup\workingscript.ps1" -WindowStyle hidden
    [int]$wait = 1

    while ((Test-Path "\\$ipaddressHost\C$\Setup\workingscript.cli") -eq 0) {
            
        Wait-Event -Timeout 4

    if ($wait -eq 1) {    
        
        $global:fieldsinmain_log = "script_id,"
        $global:fields = "12,"
        $global:events_id = "41"
        MySQLWrite
    }

    if ($wait -eq 12) {
        [int]$wait = 1
        $global:fieldsinmain_log = "script_id,"
        $global:fields = "12,"
        $global:events_id = "42"
        MySQLWrite
        # После 10 проверки будет перезапуск процесса который создает файл workingscript.cli
        exit
    }

    [int]$wait = $wait + 1

    }

    $global:workingscriptCLI = Import-Clixml -Path "\\$ipaddressHost\C$\Setup\workingscript.cli"
    Remove-Item  "\\$ipaddressHost\C$\Setup\workingscript.cli" -Force

    # зацикливаем поиск процесса пока он не завершится и перезапускаем скрипт для поиска процесса с нужным PID
    while ( $workingscriptCLI -eq 1) {

        Start-Process -FilePath .\rest_api\config\bin\PsExec.exe -ArgumentList "\\$ipaddressHost powershell -ExecutionPolicy Bypass -File C:\Setup\workingscript.ps1" -WindowStyle hidden
        [int]$wait = 1
        while ((Test-Path "\\$ipaddressHost\C$\Setup\workingscript.cli") -eq 0) {
            
            Wait-Event -Timeout 4
                
    if ($wait -eq 1) {    
        
        $global:fieldsinmain_log = "script_id,"
        $global:fields = "11,"
        $global:events_id = "43"
        MySQLWrite
    }

    if ($wait -eq 12) {
        [int]$wait = 1
        $global:fieldsinmain_log = "script_id,"
        $global:fields = "11,"
        $global:events_id = "44"
        MySQLWrite
        # После 10 проверки будет перезапуск процесса который создает файл workingscript.cli
        exit
    }

        [int]$wait = $wait + 1

    }

        $global:workingscriptCLI = Import-Clixml -Path "\\$ipaddressHost\C$\Setup\workingscript.cli"
        Remove-Item  "\\$ipaddressHost\C$\Setup\workingscript.cli" -Force
        Wait-Event -Timeout 4

}

# удаляем скрипты "проверки запуска процесса"
Remove-Item  "\\$ipaddressHost\C$\Setup\workingscript.ps1" -Force
$global:fieldsinmain_log = "script_id, "
$global:fields = "13, "
$global:events_id = "45"
MySQLWrite

Remove-Item "\\$ipaddressHost\C$\Setup\$scriptname" -Force
$global:fieldsinmain_log = "script_id, "
$global:fields = "14, "
$global:events_id = "45"
MySQLWrite

}