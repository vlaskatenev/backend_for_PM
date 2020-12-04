Import-Module .\config\Modules\14logsWrite
Import-Module .\config\Modules\15programmVariables


For (   [int]$i = 0;
        $i -LT $allProgramm.Length;
        $i += 1 ) {

        #####################################################################
        # Назначение переменных для софта. Начало 

        $Global:procName = $programms[$i].procName

        #####################################################################

        $Global:ProgrammName = $programms[$i].ProgrammName

        #####################################################################

        $Global:procDescription = $programms[$i].procDescription

        #####################################################################

        $Global:ShortProgrammName = $programms[$i].ShortProgrammName

        #####################################################################

        $Global:ProgrammFile = $programms[$i].ProgrammFile

        #####################################################################

        $Global:key = $programms[$i].key

        #####################################################################

        $Global:DistributeName = $programms[$i].DistributeName

        #####################################################################

        $Global:programmShortcuts = $programms[$i].programmShortcuts

        # Назначение переменных для софта. Конец
        #####################################################################

        . .\template.ps1

}

        logsWrite -eventsId 50



        # что за PID?????
        Stop-Process -ID $PID -Force

