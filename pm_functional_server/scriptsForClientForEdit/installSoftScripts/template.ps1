
#####################################################################
# Проверка установлен ли софт. Начало
Import-Module .\simpleFunctions
Import-Module .\checkingOperations

# запись события о старте установки приложения в SQL
logsWrite -eventsId 38 -softDisplayName $softDisplayName

logsWrite -fieldsinmainLog "script_id," -fields "1," -eventsId 37

# Проверка установлен ли софт. Конец
#####################################################################

if (findDisplayNameInReg -softDisplayName $softDisplayName) {
        logsWrite -eventsId 7 -softDisplayName $softDisplayName
} else {
        # копируем дистрибутив
        copyFile -url $urlToProgrammFile
        
        $processId = installExe -installer $programmFile -key $key
        while ((checkInstallingSoft -softDisplayName $softDisplayName -processId $processId) -eq $processId) {
                Wait-Event -Timeout 10
        }
        
        # Создание задачи в планировщике Windows
        newScheduledTaskTrigger -shortProgrammName $shortProgrammName -programmFile $programmFile
}

 # Запись в БД события об успешном завершении процесса установки
logsWrite -eventsId 52 -softDisplayName $softDisplayName
