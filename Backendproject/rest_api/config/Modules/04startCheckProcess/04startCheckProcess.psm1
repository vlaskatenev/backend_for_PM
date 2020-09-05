
#функция проверяет запущен ли процесс установщика на хосте
# запускается в цикле while в файле template.ps1 покак не завершится работа установщика
# template.ps1 48 и 62 строка
function startCheckProcess {

        Import-Module .\rest_api\config\Modules\13ChekRemoveFile
        Import-Module .\rest_api\config\Modules\checkingProcessTask

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
        
	$global:fieldsinmain_log = "script_id, "
	$global:fields = "8, "
	$global:events_id = "14"
	MySQLWrite

}

if ($procStatus -eq 1) {

	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "40"
        MySQLWrite
        [int]$global:waitCheckProcess = $null

} else {
		
	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "18"
        MySQLWrite
        [int]$global:waitCheckProcess += 1

if ($waitCheckProcess -eq 5) {

        #$global:logSTring = "$ProgrammName process not started for 5 checkout checks!!!!!"
	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "22"
	MySQLWrite

}
}
}