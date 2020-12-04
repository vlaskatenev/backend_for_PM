
#функция проверяет запущен ли процесс установщика на хосте
# запускается в цикле while в файле template.ps1 покак не завершится работа установщика
# template.ps1 48 и 62 строка

Import-Module .\config\Modules\14logsWrite
Import-Module .\rest_api\config\Modules\13ChekRemoveFile
Import-Module .\rest_api\config\Modules\checkingProcessTask

function startCheckProcess {

        $procMonitorScript = "
        Export-Clixml -Path C:\setup\valuePID.cli -Encoding UTF8 -InputObject `$PID

                [string]`$procInstaller = Get-Process `"$procName`" | Select-Object { `$_.Description }

        if ((`$procInstaller -like `"*$procDescription*`") -eq `$true) {

                [bool]`$proczapusk = 1

        } else {

                [bool]`$proczapusk = 0

        }

                [string]`$procUserName = (Get-Process `"$procName`" -IncludeUserName | Select-Object { `$_.UserName })

        if ((`$procUserName -like `"*`$env:USERNAME*`") -eq `$true) {

                [bool]`$procUserName = 1

        } else {

                [bool]`$procUserName = 0

        }

                `$procStatus = [bool]`$procUserName -and [bool]`$proczapusk


                Export-Clixml -Path C:\Setup\proczapusk.cli -Encoding UTF8 -InputObject `$procStatus"


                $global:scriptname = "procMonitorScript$ComputerName.ps1"
                $global:fileMakedScript = $procMonitorScript
                checkingProcessTask
        
        $procStatusFull = $null
        $procStatusFull = Import-Clixml -Path "\\$ipaddressHost\c$\Setup\proczapusk.cli"
        $procStatus = $procStatusFull

if ($procStatus -ne $null) {

        $global:FileDelete = "\\$ipaddressHost\c$\Setup\proczapusk.cli"
        ChekRemoveFile

} else {
        
        logsWrite -fieldsinmainLog "script_id," -fields "8," -eventsId 14

}

if ($procStatus -eq 1) {
        logsWrite -eventsId 40
        [int]$global:waitCheckProcess = $null
} else {
        logsWrite -eventsId 18
        [int]$global:waitCheckProcess += 1

if ($waitCheckProcess -eq 5) {
        logsWrite -eventsId 22
}
}
}