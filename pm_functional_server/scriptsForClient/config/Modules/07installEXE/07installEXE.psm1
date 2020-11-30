# функция запускает установщик софта - просто загруженый 
Import-Module .\rest_api\config\Modules\14logsWrite

function installEXE { 

        Wait-Event -Timeout 15

# Установка софта

        $uuu = "\\$ipaddressHost c:\Setup\$ProgrammFile $key"

# Установка дистрибутива в PsExec

        logsWrite -programName $ProgrammName -eventsId 25
        Start-Process -FilePath ".\rest_api\config\bin\PsExec.exe" -ArgumentList "$uuu" -WindowStyle hidden

# Конец кода с установкой дистрибутива в PsExec

}