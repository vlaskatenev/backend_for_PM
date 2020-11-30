# функция проверет установлен ли переданный в переменную choice номер софта
# на хосте создает скрипт который потом запускается в powershell и сохраняет в файл список софта из ветки реестра 
# HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall и HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall 
# записи DisplayName
# сканирует этот файл на ниличие в нем имени программы которая устанавливается

function checkinstallsoft { 

        Import-Module .\config\Modules\14logsWrite
        Import-Module .\config\Modules\13ChekRemoveFile
        Import-Module .\config\Modules\checkingProcessTask

        #####################################################################
        # Проверка установлен ли софт

$check_softFile = "
#####################################################3
# начало check_soft.ps1

Export-Clixml -Path C:\setup\valuePID.cli -Encoding UTF8 -InputObject `$PID

`$allSoft = dir 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall' | Select-Object { `$_.PSChildName }
        `$WriteArray = `$allSoft
        `$allSoft1 = dir 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall' | Select-Object { `$_.PSChildName }
        `$DisplayName32 = `$allSoft1

For (   [int]`$i = 0;
        `$i -LT `$allSoft.Count;
        `$i = `$i + 1 ) {

        [string]`$choice = `$allSoft[`$i]
        `$choice = `$choice -replace '^@\{ \`$_.PSChildName ='
        `$choice = `$choice.Trim()
        `$choice = `$choice -replace '}$'
        `$DriverUpdate = Get-ItemProperty -Path `"HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\`$choice`" 
        `$WriteArray[`$i] = `$DriverUpdate.UninstallString
        `$DisplayName32[`$i] = `$DriverUpdate.DisplayName
        `$ArraytoTextDisplayName = `$DisplayName32[`$i]

}

        `$allSoft = dir 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall' | Select-Object { `$_.PSChildName }
        `$WriteArray = `$allSoft
        `$allSoft1 = dir 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall' | Select-Object { `$_.PSChildName }
        `$DisplayName64 = `$allSoft1

For (   [int]`$i = 0;
        `$i -LT `$allSoft.Count;
        `$i = `$i + 1 ) {

        [string]`$choice = `$allSoft[`$i]
        `$choice = `$choice -replace '^@\{ \`$_.PSChildName ='
        `$choice = `$choice.Trim()
        `$choice = `$choice -replace '}$'
        `$DriverUpdate = Get-ItemProperty -Path `"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\`$choice`" 
        `$WriteArray[`$i] = `$DriverUpdate.UninstallString
        `$DisplayName64[`$i] = `$DriverUpdate.DisplayName
        `$ArraytoTextDisplayName = `$DisplayName64[`$i]

}

        Export-Clixml -Path `"C:\Setup\hashUninstallStringAndDisplayName.cli`" -Encoding UTF8 -InputObject `$DisplayName32, `$DisplayName64

# конец check_soft.ps1
######################################################
"

        $global:scriptname = 'check_soft.ps1'
        $global:fileMakedScript = $check_softFile
        checkingProcessTask
       
        $NewArray1 = Import-Clixml -Path "\\$ipaddressHost\c$\Setup\hashUninstallStringAndDisplayName.cli"

        if ($NewArray1.Count -eq 2) {

                Remove-Item -Path "\\$ipaddressHost\c$\Setup\hashUninstallStringAndDisplayName.cli" -Force
                logsWrite -programName $ProgrammName -fieldsinmainLog "script_id," -fields "6," -eventsId 37

        }
        else {
                logsWrite -programName $ProgrammName -eventsId 36
                exit
        }

        $allSoft32 = $NewArray1[0]
        $allSoft64 = $NewArray1[1]
        $string64 = $allSoft64 -like "*$ProgrammName*"

        if ($string64.Length -ne 0) {
                logsWrite -programName $ProgrammName -eventsId 9
                $Global:SoftHave = 0

        }
        else {

                $string32 = $allSoft32 -like "*$ProgrammName*"

                if ($string32.Length -ne 0) {
                        logsWrite -programName $ProgrammName -eventsId 8     
                        $Global:SoftHave = 0

                }
                else {
                        logsWrite -eventsId 2
                        $Global:SoftHave = 1

                }
        }
}