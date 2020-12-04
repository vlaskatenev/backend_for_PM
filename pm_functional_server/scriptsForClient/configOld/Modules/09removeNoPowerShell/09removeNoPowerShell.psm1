# создаем скрипт который будет запускаться в планировщике и создаем задание на выполнение этого скрипта
Import-Module .\rest_api\config\Modules\14logsWrite
Import-Module .\rest_api\config\Modules\13ChekRemoveFile
Import-Module .\rest_api\config\Modules\checkingProcessTask

function removeNoPowerShell {

# Делаем скрипт для создания задания в планировщике заданий

        $taskScheduledTaskTrigger =  "  Export-Clixml -Path C:\setup\valuePID.cli -Encoding UTF8 -InputObject `$PID
                                        `$Trigger= New-ScheduledTaskTrigger -AtStartup 
                                        `$User= `"NT AUTHORITY\SYSTEM`"
                                        `$Action= New-ScheduledTaskAction -Execute `"PowerShell.exe`" -Argument `"-ExecutionPolicy Bypass -File C:\Setup\StartupScript$ShortProgrammName.ps1`"
                                        Register-ScheduledTask -TaskName `"StartupScript$ShortProgrammName`" -Trigger `$Trigger -User `$User -Action `$Action -RunLevel Highest –Force"
        
        $global:scriptname = "ScheduledTaskTrigger$ShortProgrammName.ps1 "
        $global:fileMakedScript = $taskScheduledTaskTrigger
        checkingProcessTask

#####################################################################

# Делаем скрипт который будет выполняться планировщиком заданий после перезагрузки ПК

        $MakeStartupScript = "  Remove-Item C:\Setup\$DistributeName -Recurse -Force
                                Unregister-ScheduledTask -TaskName StartupScript$ShortProgrammName -Confirm:$false
                                Remove-Item C:\Setup\StartupScript$ShortProgrammName.ps1 -Force"

        $MakeStartupScript | Out-File -Encoding UTF8 \\$ComputerName\C$\Setup\StartupScript$ShortProgrammName.ps1

#####################################################################
 




# Удаление загруженных дистрибутивов с PsExec

        $global:FileDelete = "\\$ipaddressHost\C$\Setup\ScheduledTaskTrigger$ShortProgrammName.ps1"   
        ChekRemoveFile

#####################################################################

        $global:FileDelete = "\\$ipaddressHost\C$\Setup\check_soft.ps1"   
        ChekRemoveFile

#####################################################################    

        $global:FileDelete = "\\$ipaddressHost\C$\Setup\procMonitorScript$ComputerName.ps1"  
        ChekRemoveFile
        
}