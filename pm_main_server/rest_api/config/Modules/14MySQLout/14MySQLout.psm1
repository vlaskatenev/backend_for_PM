
function MySQLWrite {

        $sql.CommandText = "INSERT INTO main_log (startnumber, date_time, ComputerName, ipaddresshost, program_name, $fieldsinmain_log events_id) VALUES ('$maxstartnumber',NOW(3),'$ComputerName', '$ipaddressHost', $choice, $fields $events_id)"
        $sql.ExecuteNonQuery() >$null 

}


function MySQLWriteWithoutProgramName {

        $sql.CommandText = "INSERT INTO main_log (startnumber, date_time, ComputerName, ipaddresshost, $fieldsinmain_log events_id) VALUES ('$maxstartnumber', NOW(3),'$ComputerName', '$ipaddressHost', $fields $events_id)"
        $sql.ExecuteNonQuery() >$null 

}

function zaprosNEW {

        $MYSQLCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
        $MYSQLDataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter
        $MYSQLDataSet = New-Object System.Data.DataSet
        $MYSQLCommand.Connection=$Connection
        $MYSQLCommand.CommandText="$fullzapros"
        $MYSQLDataAdapter.SelectCommand=$MYSQLCommand
        $NumberOfDataSets=$MYSQLDataAdapter.Fill($MYSQLDataSet, "data")
        $text = $MYSQLDataSet.tables | Out-String
        $text = $text -replace "$zapros"
        $text = $text -replace "--*--"
        $text = $text.Trim()
        $global:text_string = $text

}


