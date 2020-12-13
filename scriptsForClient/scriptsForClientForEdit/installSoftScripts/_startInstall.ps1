Import-Module .\simpleFunctions

. C:\Setup\installSoftScripts\programmVariables.ps1

For (   [int]$i = 0;
        $i -LT $programms.Length;
        $i += 1 ) {

        #####################################################################
        # Назначение переменных для софта. Начало 
        # Имя программы, которое будет искаться в реестре        
        $softDisplayName = $programms[$i].softDisplayName

        #####################################################################
        # короткое имя программы. Необходимо для создания скриптов        
        $shortProgrammName = $programms[$i].ShortProgrammName

        #####################################################################
        # файл программы установщика
        $programmFile = $programms[$i].ProgrammFile

        #####################################################################
        # ключ для тихой установки
        $key = $programms[$i].key

        #####################################################################

        $urlToProgrammFile = $programms[$i].urlToProgrammFile

        # Назначение переменных для софта. Конец
        #####################################################################

        . .\template.ps1

}

requestToFunctionalServer -postParams $idInstall

logsWrite -eventsId 50
Stop-Process -ID $PID -Force

