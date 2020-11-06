function startInstallZIP { 

        Import-Module .\rest_api\config\Modules\14MySQLout
        Import-Module .\rest_api\config\Modules\checkingProcessTask

# начало копирования и распаковки

         
        #$global:logSTring = "$archive starting copy"
	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "24"
        MySQLWrite

# Импортируем модуль BITS

        Import-Module BitsTransfer

# Запускаем закачку асинхронно

        Start-BitsTransfer -Source $PathtoSetup\Setup\$archive -Destination \\$ipaddressHost\C$\Setup\$archive -Priority low


        $TestPath = Test-Path -Path "\\$ipaddressHost\C$\Setup\$archive"

    
if ($TestPath -eq 1) {

        #$global:logSTring = "$archive installer copied"
	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "11"
        MySQLWrite
        
} else {

        #$global:logSTring = "$archive installer NOT copied"
	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "12"
        MySQLWrite
        exit
        
}
}

function CopyExeFile { 

        Add-Type –Path 'C:\Program Files (x86)\MySQL\Connector NET 8.0\Assemblies\v4.5.2\MySql.Data.dll'
        Import-Module .\rest_api\config\Modules\14MySQLout

# Установка софта с установщика без архива
       
        #$global:logSTring = "$ProgrammName starting copy on computer"
	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "24"
        MySQLWrite

# Копируем дистрибутивы не в архиве zip

# Импортируем модуль BITS

        Import-Module BitsTransfer

# Запускаем закачку асинхронно

        Start-BitsTransfer -Source $PathtoSetup\Setup\$ProgrammFile -Destination \\$ipaddressHost\C$\Setup\$ProgrammFile -Priority low

# Завершение копирования дистрибутива

        $TestPath = Test-Path -Path "\\$ipaddressHost\C$\Setup\$ProgrammFile"

if ($TestPath -eq 1) {

        #$global:logSTring = "$ProgrammName downloaded to computer"
	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "4"
        MySQLWrite
 
} else {

        #$global:logSTring = "$ProgrammName NOT downloaded to computer"
	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "15"
        MySQLWrite
        exit
        
}
}