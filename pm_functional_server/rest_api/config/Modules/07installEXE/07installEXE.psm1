# функция запускает установщик софта - просто загруженый 

function installEXE { 

        Import-Module .\rest_api\config\Modules\14MySQLout
        Wait-Event -Timeout 15

# Установка софта

        $uuu = "\\$ipaddressHost c:\Setup\$ProgrammFile $key"

# Установка дистрибутива в PsExec

        #$global:logSTring = "$ProgrammName starting install"
	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "25"
        MySQLWrite
        Start-Process -FilePath ".\rest_api\config\bin\PsExec.exe" -ArgumentList "$uuu" -WindowStyle hidden

# Конец кода с установкой дистрибутива в PsExec

}