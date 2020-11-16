Param (
[Parameter (Mandatory=$true, Position=1)]
[string]$Global:ComputerName,

[Parameter (Mandatory=$true, Position=2)]
[string]$global:programm1,

[Parameter (Mandatory=$true, Position=3)]
[int]$Global:maxstartnumber

)

. $env:APPDATA\varForWorkPineapples.ps1

Import-Module .\rest_api\config\Modules\14MySQLout
Import-Module .\rest_api\config\Modules\02check-Host-availability

# проверяем доступность ПК
checkHostavailability


Write-Host $global:programm
$global:programm = $global:programm1.split("s")
Write-Host $global:programm

For (   [int]$i = 0;
        $i -LT $global:programm.Length;
        $i += 1 ) {

        $choice = $global:programm[$i]

        #####################################################################


        #####################################################################
        # Назначение переменных для софта. Начало 

        $global:zapros = "procName"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;" 
        zaprosNEW
        $Global:procName = $text_string

        #####################################################################

        $global:zapros = "programname"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:ProgrammName = $text_string

        #####################################################################

        $global:zapros = "procDescription"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:procDescription = $text_string

        #####################################################################

        $global:zapros = "shortprogramname"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:ShortProgrammName = $text_string

        #####################################################################

        $global:zapros = "programfile"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:ProgrammFile = $text_string

        #####################################################################

        $global:zapros = "keystring"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:key = $text_string

        #####################################################################

        $global:zapros = "zip"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:zip = $text_string

        #####################################################################

        $global:zapros = "archive"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:archive = $text_string

        #####################################################################

        $global:zapros = "distributename"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:DistributeName = $text_string

        #####################################################################

        $global:zapros = "programshortcut"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:programmShortcuts = $text_string

        #####################################################################

        $global:zapros = "driveletter"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:DriveLetter = $text_string

        #####################################################################

        $global:zapros = "pathtosetup"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:Path = $text_string

        #####################################################################

        $global:zapros = "hashoriginalfile"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:hashoriginalfile = $text_string

        #####################################################################

        $global:zapros = "hashprograminstaller"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosNEW
        $Global:hashprograminstaller = $text_string

        # Назначение переменных для софта. Конец
        #####################################################################

        . .\rest_api\config\template.ps1

}

        $global:fieldsinmain_log = ""
        $global:fields = ""
        $global:events_id = "50"
        MySQLWriteWithoutProgramName

        Stop-Process -ID $PID -Force

