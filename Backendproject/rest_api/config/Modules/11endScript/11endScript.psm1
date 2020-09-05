function endScript { 
      
        Import-Module .\rest_api\config\Modules\14MySQLout
           
# Завершение скрипта
        
        #$global:logSTring = "script work sucsessful"
	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "23"
        MySQLWriteWithoutProgramName

}