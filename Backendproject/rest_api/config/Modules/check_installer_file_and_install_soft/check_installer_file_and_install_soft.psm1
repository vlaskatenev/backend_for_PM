# copyinstallerNEW - копирует дистрибутив на компьютер. Это архив zip и инсталлятор
function copyinstallerNEW {

    Import-Module .\rest_api\config\Modules\06CopyInstallerFile

   if ($zip -eq 1) {

           #####################################################################

           # начало копирования ZIP

           startInstallZIP

           # Конец
           #####################################################################

   }
   else {

           #####################################################################
           # Копирование EXE Начало

           CopyExeFile

           # Конец
           #####################################################################

   }
}


#################################################################################
# Следующая функция отвечает за проверку загруженных файлов по хешу MD5
# checkhashinstallerfile проверяет файлы установщика или zip архивы на целостность по хешу MD5
function checkhashinstallerfile {

Import-Module .\rest_api\config\Modules\14MySQLout
Import-Module .\rest_api\config\Modules\07installEXE
Import-Module .\rest_api\config\Modules\06CopyInstallerFile
Import-Module .\rest_api\config\Modules\checkingProcessTask

# Если файл программы есть то просто проверяется его хэш, будь это архив или отдельный файл
# $Global:ProgrammFile - имя файла если это не архив
# $Global:archive - имя файла если это архив


if ($zip -eq 1) {

    $installerfile = $Global:archive

}
else {

    $installerfile = $Global:ProgrammFile

}


    $hashinstallerfile = "
    Export-Clixml -Path C:\setup\valuePID.cli -Encoding UTF8 -InputObject `$PID
    `$hash = (Get-ChildItem -Path C:\setup\$installerfile | Get-FileHash -Algorithm MD5)
    `$hash1 = `$hash.Hash
    Export-Clixml -Path C:\setup\hash1.cli -Encoding UTF8 -InputObject `$hash1
    "


$global:scriptname = "hashinstallerfile.ps1"
                $global:fileMakedScript = $hashinstallerfile
                checkingProcessTask
                if ((Test-Path "\\$ipaddressHost\C$\Setup\hash1.cli") -eq 1) {
                    $global:hash1 = Import-Clixml -Path "\\$ipaddressHost\C$\Setup\hash1.cli"
                    Remove-Item  "\\$ipaddressHost\C$\Setup\hash1.cli" -Force 
                   # Write-Host "Хеш списка файлов загружен"
                    $global:fieldsinmain_log = "script_id,"
                    $global:fields = "12,"
                    $global:events_id = "27"
                    MySQLWrite
                
                    if ($global:hash1 -like "$hashoriginalfile") {

                        # Write-Host "Хеш списка файлов сходится с оригинальным"
                        $global:fieldsinmain_log = "script_id,"
                        $global:fields = "12,"
                        $global:events_id = "47"
                        MySQLWrite
                        
                    } else {
               
                        # если все же хеши не равны то будет софт загружен заново. Только нужно удалить старый дистрибутив
                        Remove-Item  "\\$ipaddressHost\C$\Setup\$installerfile" -Force 

                            if ((Test-Path "\\$ipaddressHost\C$\Setup\$installerfile") -eq 0) {

                                copyinstallerNEW

                            } else {

                                #Write-Host "Файл $installerfile не удалился"
                                $global:fieldsinmain_log = "script_id,"
                                $global:fields = "12,"
                                $global:events_id = "35"
                                MySQLWrite

                            }
        
                    }
                
                } else {
                
                    #Write-Host "Хеш списка файлов НЕ загружен"
                    $global:fieldsinmain_log = "script_id,"
                    $global:fields = "12,"
                    $global:events_id = "29"
                    MySQLWrite
                
                }
            }

#########################################################################################
# Если был загружен архив с программой - об будет разархивирован этой функцией
            function extractarchive {
                ###############################################################
                # Разархивирование архива с помощью Powershell и удаление файла архива. Начало
                    if ($zip -eq 1) {    

                    Import-Module .\rest_api\config\Modules\checkingProcessTask
                    $ExportPoSh = "
                                    Export-Clixml -Path C:\setup\valuePID.cli -Encoding UTF8 -InputObject `$PID
                                    Expand-Archive -Path C:\Setup\$archive  -DestinationPath C:\Setup -Force"
                    
                    $global:scriptname = "ExtractArchive$ipaddressHost.ps1"
                    $global:fileMakedScript = $ExportPoSh
                    checkingProcessTask
                    
                    }
                }
                
                
##########################################################################################
# Проверка разархивированных файлов если софт находится в архиве zip, установка софта
function checkinstallerfileandinstallsoft {

if ($zip -eq 1) {  

    Import-Module .\rest_api\config\Modules\14MySQLout
    Import-Module .\rest_api\config\Modules\07installEXE
    Import-Module .\rest_api\config\Modules\06CopyInstallerFile
    Import-Module .\rest_api\config\Modules\checkingProcessTask
    Import-Module .\rest_api\config\Modules\13ChekRemoveFile

    # Проверка загруженного (или разархивированного архива) дистрибутива на целостность по вычисленю хешей всех файлов (если дистрибути из нескольких и больше файлов)
    # и сравнение их с приоритетным - указанным в переменной. 

    $hashinstallerfiles = "
    Export-Clixml -Path C:\setup\valuePID.cli -Encoding UTF8 -InputObject `$PID
    `$hash = (Get-ChildItem -Path C:\setup\$Global:distributename -Recurse * | Get-FileHash -Algorithm MD5)
    `$hash3 = `$hash.Hash
    `$hash3 | Out-File -Encoding UTF8 C:\setup\hash3.cli
    # узнаем md5 для файла со всеми хешами фалов дистрибутива. Здесь будет алгоритм проверхи MD5 хеша
    `$hash1 = Get-FileHash C:\setup\hash3.cli -Algorithm MD5
    `$hash2 = `$hash1.Hash
    Export-Clixml -Path C:\setup\hash1.cli -Encoding UTF8 -InputObject `$hash2
    Remove-Item C:\setup\hash3.cli
    "

    $global:scriptname = "hashinstallerfiles.ps1"
    $global:fileMakedScript = $hashinstallerfiles
    checkingProcessTask

    # Проверка на серверной части
    [int]$count = 0
    while ($count -ne 1) {

    if ((Test-Path "\\$ipaddressHost\C$\Setup\hash1.cli") -eq 1) {
        $global:hash2 = Import-Clixml -Path "\\$ipaddressHost\C$\Setup\hash1.cli"
        Remove-Item  "\\$ipaddressHost\C$\Setup\hash1.cli" -Force 
        #Write-Host "Хеш списка файлов загружен"
        $global:fieldsinmain_log = "script_id,"
        $global:fields = "12,"
        $global:events_id = "27"
        MySQLWrite

        if ($global:hash2 -like "$Global:hashprograminstaller") {
            # цикл завершается когда $count = 1 
            $count = 1 
            #Write-Host "Хеш списка файлов сходится с оригинальным"
            $global:fieldsinmain_log = "script_id,"
            $global:fields = "12,"
            $global:events_id = "47"
            MySQLWrite
            # После проверки Архива zip на целостность он будут удален

            $global:FileDelete = "\\$ipaddressHost\C$\Setup\ExtractArchive$ipaddressHost.ps1" 
            ChekRemoveFile

            Wait-Event -Timeout 5
            $global:FileDelete = "\\$ipaddressHost\C$\Setup\$archive"     
            ChekRemoveFile 
            # Начинается установка софта если хеш у софта сходится с номинальным. 
            # Установка после первой удачной проверки файлов на целостность   
            installEXE
            
        } else {

            # если все же хеши не равны то будет софт разархивирован заново и перезапуск скрипта по определению хеша
            #Write-Host "Хеш списка файлов НЕ сходится с оригинальным"

            Remove-Item C:\Setup\$DistributeName -Recurse -Force

            extractarchive

            $global:scriptname = "hashinstallerfiles.ps1"
            $global:fileMakedScript = $hashinstallerfiles
            checkingProcessTask
            $global:hash1 = Import-Clixml -Path "\\$ipaddressHost\C$\Setup\hash1.cli"
            $count += 1

            Remove-Item  "\\$ipaddressHost\C$\Setup\hash1.cli" -Force 
            #Write-Host "Хеш списка файлов загружен"
            $global:fieldsinmain_log = "script_id,"
            $global:fields = "12,"
            $global:events_id = "27"
            MySQLWrite

            if ($global:hash2 -like "$Global:hashprograminstaller") {
                # цикл завершается когда $count = 1 
                $count = 1 
                #Write-Host "Хеш списка файлов сходится с оригинальным"
                $global:fieldsinmain_log = "script_id,"
                $global:fields = "12,"
                $global:events_id = "47"
                MySQLWrite
                installEXE
                
            } else {

                #Write-Host "Хеш списка файлов НЕ сходится с оригинальным"
                $global:fieldsinmain_log = ""
                $global:fields = ""
                $global:events_id = "48"
                MySQLWrite
                $global:FileDelete = "\\$ipaddressHost\C$\Setup\$archive"     
                ChekRemoveFile 
                $global:FileDelete = "\\$ipaddressHost\C$\Setup\$DistributeName"     
                ChekRemoveFile 
                Write-Host "Хеш списка файлов НЕ сходится с оригинальным, архив и разархивированный софт удален"

            }   
        }

    } else {

        #Write-Host "Хеш списка файлов НЕ загружен"
        $global:fieldsinmain_log = "script_id,"
        $global:fields = "12,"
        $global:events_id = "29"
        MySQLWrite

    }
    }
    } else {

        # Запуск установки софта если установка проходит с инсталлятора, а не с архива
        installEXE

    }
}
