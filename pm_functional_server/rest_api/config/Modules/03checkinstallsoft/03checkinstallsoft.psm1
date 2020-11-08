# функция проверет установлен ли переданный в переменную choice номер софта
# на хосте создает скрипт который потом запускается в powershell и сохраняет в файл список софта из ветки реестра 
# HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall и HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall 
# записи DisplayName
# сканирует этот файл на ниличие в нем имени программы которая устанавливается

function checkinstallsoft { 

        Import-Module .\rest_api\config\Modules\14MySQLout
        Import-Module .\rest_api\config\Modules\13ChekRemoveFile
        Import-Module .\rest_api\config\Modules\checkingProcessTask

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
                $global:fieldsinmain_log = "script_id,"
                $global:fields = "6,"
                $global:events_id = "37"
                MySQLWrite

        }
        else {

                $global:fieldsinmain_log = ""
                $global:fields = ""
                $global:events_id = "36"
                MySQLWrite
                exit

        }

        $allSoft32 = $NewArray1[0]
        $allSoft64 = $NewArray1[1]
        $string64 = $allSoft64 -like "*$ProgrammName*"

        if ($string64.Length -ne 0) {

                $global:fieldsinmain_log = ""
                $global:fields = ""
                $global:events_id = "9"
                MySQLWrite
                $Global:SoftHave = 0

        }
        else {

                $string32 = $allSoft32 -like "*$ProgrammName*"

                if ($string32.Length -ne 0) {

                        $global:fieldsinmain_log = ""
                        $global:fields = ""
                        $global:events_id = "8"
                        MySQLWrite      
                        $Global:SoftHave = 0

                }
                else {

                        $global:fieldsinmain_log = ""
                        $global:fields = ""
                        $global:events_id = "2"
                        MySQLWrite
                        $Global:SoftHave = 1

                }
        }
}