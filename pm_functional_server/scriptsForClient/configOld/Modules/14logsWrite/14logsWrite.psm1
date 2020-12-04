
function logsWrite {
        Param (
        [string]$fieldsinmainLog,
        [string]$fields,
        $logString=$False,
        [int]$eventsId
        )
        $curDate = Get-Date
        if ($logString) {
                Write-Output "$curDate, $logString" >> proc.txt
        } else {
                Write-Output "$curDate, programName $Global:ProgrammName, $fieldsinmainLog $fields events_id $eventsId" >> proc.txt
        }

}
