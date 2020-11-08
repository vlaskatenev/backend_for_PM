function ChekRemoveFile {

        Import-Module .\rest_api\config\Modules\14MySQLout
        $TestPath = Test-Path -Path $FileDelete

if ($TestPath -eq $true) {

        Remove-Item $FileDelete -Recurse 
        $TestPath = Test-Path -Path $FileDelete

if ($TestPath -eq $false) {
     
        $global:logSTring = "$FileDelete was deleted"
        MySQLWrite     
        
} else {
     
        $global:logSTring = "$FileDelete was NOT deleted, maybe the file is blocked by the process"
        MySQLWrite 

} 
} else {
              
        $global:logSTring = "$FileDelete no file"
        MySQLWrite

}
}
