Import-Module .\rest_api\config\Modules\14logsWrite

function endScript { 
        # Завершение скрипта
        logsWrite -eventsId 23
}