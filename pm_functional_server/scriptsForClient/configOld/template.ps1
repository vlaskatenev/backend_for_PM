
#####################################################################
# Проверка установлен ли софт. Начало
Import-Module .\config\Modules\14logsWrite
Import-Module .\config\Modules\03checkinstallsoft
Import-Module .\config\Modules\04startCheckProcess
Import-Module .\config\Modules\check_installer_file_and_install_soft
Import-Module .\config\Modules\09removeNoPowerShell

# запись события о старте установки приложения в SQL
logsWrite -eventsId 38

checkinstallsoft

logsWrite -fieldsinmainLog "script_id," -fields "1," -eventsId 37

# Проверка установлен ли софт. Конец
#####################################################################

if ($SoftHave -eq 0) {

        logsWrite -eventsId 7

} else {

        # копируем дистрибутив или архив zip 
        copyinstallerNEW
        # Следующая функция отвечает за проверку загруженных файлов по хешу MD5
        # checkhashinstallerfile
        # Если был загружен архив с программой - об будет разархивирован этой функцией
        # extractarchive
        # Проверка загруженного (или разархивированного архива) дистрибутива на целостность по вычисленю хешей всех файлов (если дистрибути из нескольких и больше файлов)
        # и сравнение их с приоритетным - указанным в переменной. 
        checkinstallerfileandinstallsoft

# начало проверки установлен ли софт после успешной проверки файлов на целостность и старта установки
        while ($SoftHave -eq 1) {

                checkinstallsoft
                startCheckProcess
                Wait-Event -Timeout 10

        }

        $folder2 = Get-ChildItem "C:\ProgramData\Microsoft\Windows\Start Menu\Programs" -Recurse -File "*$programmShortcuts*"

        while ($folder2 -eq $null) {

                $folder2 = Get-ChildItem "C:\ProgramData\Microsoft\Windows\Start Menu\Programs" -Recurse -File "*$programmShortcuts*"
                logsWrite -eventsId 3
                startCheckProcess
                Wait-Event -Timeout 10

        }

        if ($folder2 -ne $null) {

                logsWrite -eventsId 10
            
        }

        # Проверка установлен ли софт - конец
        #####################################################################
        
        # Удаление загруженных файлов
        removeNoPowerShell

        # Удаление загруженных файлов. Конец

}

 # Запись в БД события об успешном завершении процесса установки
        logsWrite -eventsId 52






