# Модуль компирует на комп архив с программой или EXE файл установщик
Import-Module .\rest_api\config\Modules\14logsWrite
Import-Module .\rest_api\config\Modules\checkingProcessTask
Import-Module BitsTransfer

function startInstallZIP { 

# начало копирования и распаковки

        logsWrite -programName $ProgrammName -eventsId 24

# Запускаем закачку асинхронно

        Start-BitsTransfer -Source $PathtoSetup\Setup\$archive -Destination \\$ipaddressHost\C$\Setup\$archive -Priority low
    
        if (Test-Path -Path "\\$ipaddressHost\C$\Setup\$archive") {

                logsWrite -programName $ProgrammName -eventsId 11
                
        } else {

                logsWrite -programName $ProgrammName -eventsId 12
                exit
                
        }
}

function CopyExeFile {

# Установка софта с установщика без архива

        logsWrite -programName $ProgrammName -eventsId 24

# Копируем дистрибутивы не в архиве zip

# Запускаем закачку асинхронно

        Start-BitsTransfer -Source $PathtoSetup\Setup\$ProgrammFile -Destination \\$ipaddressHost\C$\Setup\$ProgrammFile -Priority low

# Завершение копирования дистрибутива

if (Test-Path -Path "\\$ipaddressHost\C$\Setup\$ProgrammFile") {

        logsWrite -programName $ProgrammName -eventsId 4
 
} else {

        logsWrite -programName $ProgrammName -eventsId 15
        exit
        
}
}