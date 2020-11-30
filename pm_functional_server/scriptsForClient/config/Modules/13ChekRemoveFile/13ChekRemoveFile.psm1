Import-Module .\rest_api\config\Modules\14logsWrite

function ChekRemoveFile {
Param (
        $fileDelete
        )

        $testPath = Test-Path -Path $fileDelete

if ($testPath) {

        Remove-Item $fileDelete -Recurse 
        $testPath = Test-Path -Path $fileDelete

if (-Not $testPath) {

        logsWrite  -logString "$fileDelete was deleted"
        
} else {
     
        logsWrite -logString "$fileDelete was NOT deleted, maybe the file is blocked by the process"

} 
} else {

        logsWrite -logString "$fileDelete no file"

}
}
