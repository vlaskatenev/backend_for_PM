
#####################################################################
# Проверка установлен ли софт. Начало

Import-Module .\rest_api\config\Modules\03checkinstallsoft
Import-Module .\rest_api\config\Modules\04startCheckProcess
Import-Module .\rest_api\config\Modules\check_installer_file_and_install_soft

# запись события о старте установки приложения в SQL
$global:fieldsinmain_log = ""
$global:fields = ""
$global:events_id = "38"
MySQLWrite

checkinstallsoft
$global:fieldsinmain_log = "script_id,"
$global:fields = "1,"
$global:events_id = "37"
MySQLWrite

# Проверка установлен ли софт. Конец
#####################################################################

if ($SoftHave -eq 0) {

        $global:fieldsinmain_log = ""
        $global:fields = ""
        $global:events_id = "7"
        MySQLWrite

}
else {

        # копируем дистрибутив или архив zip 
        copyinstallerNEW 
        # Следующая функция отвечает за проверку загруженных файлов по хешу MD5
        checkhashinstallerfile
        # Если был загружен архив с программой - об будет разархивирован этой функцией
        extractarchive
        # Проверка загруженного (или разархивированного архива) дистрибутива на целостность по вычисленю хешей всех файлов (если дистрибути из нескольких и больше файлов)
        # и сравнение их с приоритетным - указанным в переменной. 
        checkinstallerfileandinstallsoft

# начало проверки установлен ли софт после успешной проверки файлов на целостность и старта установки
        while ($SoftHave -eq 1) {

                checkinstallsoft
                startCheckProcess
                Wait-Event -Timeout 10

        }

        $folder2 = Get-ChildItem "\\$ipaddressHost\C$\ProgramData\Microsoft\Windows\Start Menu\Programs" -Recurse -File "*$programmShortcuts*"

        while ($folder2 -eq $null) {

                $folder2 = Get-ChildItem "\\$ipaddressHost\C$\ProgramData\Microsoft\Windows\Start Menu\Programs" -Recurse -File "*$programmShortcuts*"
                $global:fieldsinmain_log = ""
                $global:fields = ""
                $global:events_id = "3"
                MySQLWrite
                startCheckProcess
                Wait-Event -Timeout 10

        }

        if ($folder2 -ne $null) {

                $global:fieldsinmain_log = ""
                $global:fields = ""
                $global:events_id = "10"
                MySQLWrite
            
        }

        # Проверка установлен ли софт - конец
        #####################################################################
        
        # Удаление загруженных файлов

        Import-Module .\rest_api\config\Modules\09removeNoPowerShell
        removeNoPowerShell

        # Удаление загруженных файлов. Конец

}

 # Запись в БД события об успешном завершении процесса установки
        $global:fieldsinmain_log = ""
        $global:fields = ""
        $global:events_id = "52"
        MySQLWrite






