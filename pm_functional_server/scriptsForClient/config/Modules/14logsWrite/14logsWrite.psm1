
function logsWrite {
        Param (
        [string]$programName="None",
        [string]$fieldsinmainLog,
        [string]$fields,
        $logString=$False,
        [int]$eventsId
        )
        $curDate = Get-Date
        if ($logString) {
                Write-Output "$curDate, $logString" >> proc.txt
        } else {
                Write-Output "$curDate, programName $programName, $fieldsinmain_log $fields events_id $events_id" >> proc.txt
        }

}
