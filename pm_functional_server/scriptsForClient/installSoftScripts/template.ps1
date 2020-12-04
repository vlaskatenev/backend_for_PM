
#####################################################################
# Проверка установлен ли софт. Начало
Import-Module .\installSoftScripts\simpleFunctions
Import-Module .\installSoftScripts\checkingOperations

# запись события о старте установки приложения в SQL
logsWrite -eventsId 38

logsWrite -fieldsinmainLog "script_id," -fields "1," -eventsId 37

# Проверка установлен ли софт. Конец
#####################################################################

if (-Not (findDisplayNameInReg -softDisplayName $programmName)) {
        logsWrite -eventsId 7
} else {
        # копируем дистрибутив
        copyFile -url $urlToProgrammFile
        
        $processId = installExe -installExe $installExe -key $key
        while ((checkInstallingSoft -softDisplayName $softDisplayName -processId $processId) -eq $processId) {
                Wait-Event -Timeout 10
        }
        
        # Создание задачи в планировщике Windows
        newScheduledTaskTrigger -shortProgrammName $shortProgrammName
}

 # Запись в БД события об успешном завершении процесса установки
logsWrite -eventsId 52

