Import-Module .\config\Modules\14logsWrite
Import-Module .\config\Modules\15programmVareables

$global:programm = allProgramm

For (   [int]$i = 0;
        $i -LT $global:programm.Length;
        $i += 1 ) {

        #####################################################################
        # Назначение переменных для софта. Начало 

        $Global:procName = $programm[$i].procName

        #####################################################################

        $Global:ProgrammName = $programm[$i].ProgrammName

        #####################################################################

        $Global:procDescription = $programm[$i].procDescription

        #####################################################################

        $Global:ShortProgrammName = $programm[$i].ShortProgrammName

        #####################################################################

        $Global:ProgrammFile = $programm[$i].ProgrammFile

        #####################################################################

        $Global:key = $programm[$i].key

        #####################################################################

        $Global:zip = $programm[$i].zip

        #####################################################################

        $Global:archive = $programm[$i].archive

        #####################################################################

        $Global:DistributeName = $programm[$i].DistributeName

        #####################################################################

        $Global:programmShortcuts = $programm[$i].programmShortcuts

        #####################################################################

        $Global:DriveLetter = $programm[$i].DriveLetter

        #####################################################################

        $Global:Path = $programm[$i].DriveLetter

        #####################################################################

        $Global:hashoriginalfile = $programm[$i].hashoriginalfile

        #####################################################################

        $Global:hashprograminstaller = $programm[$i].hashprograminstaller

        # Назначение переменных для софта. Конец
        #####################################################################

        . .\template.ps1

}

        logsWrite -eventsId 50



        # что за PID?????
        Stop-Process -ID $PID -Force

