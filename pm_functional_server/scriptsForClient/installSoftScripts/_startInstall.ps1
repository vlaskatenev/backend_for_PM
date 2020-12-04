Import-Module .\config\Modules\14logsWrite
Import-Module .\config\Modules\15programmVariables


For (   [int]$i = 0;
        $i -LT $allProgramm.Length;
        $i += 1 ) {

        #####################################################################
        # Назначение переменных для софта. Начало 

        $procName = $programms[$i].procName

        #####################################################################

        $programmName = $programms[$i].ProgrammName

        #####################################################################

        $procDescription = $programms[$i].procDescription

        #####################################################################

        $shortProgrammName = $programms[$i].ShortProgrammName

        #####################################################################

        $programmFile = $programms[$i].ProgrammFile

        #####################################################################

        $key = $programms[$i].key

        #####################################################################

        $distributeName = $programms[$i].DistributeName

        #####################################################################

        $programmShortcuts = $programms[$i].programmShortcuts

        $urlToProgrammFile = $programms[$i].urlToProgrammFile

        # Назначение переменных для софта. Конец
        #####################################################################

        . .\template.ps1

}

logsWrite -eventsId 50
Stop-Process -ID $PID -Force

