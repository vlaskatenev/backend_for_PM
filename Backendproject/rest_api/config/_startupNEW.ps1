

Param (
[string]$global:computername,
[string]$global:ipaddressHost,
$Global:maxstartnumber
)

. $env:APPDATA\varForWorkPineapples.ps1

$sql.CommandText = "SET lc_time_names = 'ru_RU';"
$sql.ExecuteNonQuery() >$null 
Import-Module .\rest_api\config\Modules\14MySQLout

$b1 = Get-Content .\temp.txt
Remove-Item .\temp.txt

foreach ($choice in  $b1) {

        #####################################################################

        Switch ($global:choice) {

                $choice {

                        $ProgrammName = $programArray.$choice
                        $global:fieldsinmain_log = ""
                        $global:fields = ""
                        $global:events_id = "38"
                        MySQLWrite
                        Wait-Event -Timeout 20
                }
        }

        #####################################################################
        # Назначение переменных для софта. Начало 

        $global:zapros = "procName"
        $global:fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;" 
        zaprosForMySQL
        $Global:procName = $text2

        #####################################################################

        $zapros = "programname"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:ProgrammName = $text2

        #####################################################################

        $zapros = "procDescription"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:procDescription = $text2

        #####################################################################

        $zapros = "shortprogramname"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:ShortProgrammName = $text2

        #####################################################################

        $zapros = "programfile"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:ProgrammFile = $text2

        #####################################################################

        $zapros = "keystring"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:key = $text2

        #####################################################################

        $zapros = "zip"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:zip = $text2

        #####################################################################

        $zapros = "archive"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:archive = $text2

        #####################################################################

        $zapros = "distributename"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:DistributeName = $text2

        #####################################################################

        $zapros = "programshortcut"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:programmShortcuts = $text2

        #####################################################################

        $zapros = "driveletter"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:DriveLetter = $text2

        #####################################################################

        $zapros = "pathtosetup"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:Path = $text2

        #####################################################################

        $zapros = "hashoriginalfile"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:hashoriginalfile = $text2

        #####################################################################

        $zapros = "hashprograminstaller"
        $fullzapros = "SELECT $zapros FROM program_var WHERE var_id=$choice;"
        zaprosForMySQL
        $Global:hashprograminstaller = $text2

        # Назначение переменных для софта. Конец
        #####################################################################

        . .\rest_api\config\template.ps1

}
