function checkHostavailability {

    Import-Module .\rest_api\config\Modules\14MySQLout

# убираем пробелы в конце и в начале имени ПК
$Global:ComputerName = $Global:ComputerName.Trim()

        $global:fieldsinmain_log = ""
	    $global:fields = ""
	    $global:events_id = "51"
        $global:ipaddressHost = ""
        MySQLWriteWithoutProgramName

#####################################################################  
# Проверка это имя компа или IP адрес. Начало

 if ($ComputerName -match '^(?!(0+\.?){4})(([01]?\d\d?|2[0-4]|25[0-5])\.){3}([01]?\d\d?|2[0-4]|25[0-5])$' -eq 1) {

        $global:ipaddressHost = $ComputerName
  
} else {
       
        $global:ipaddressHost = ([System.Net.Dns]::GetHostAddresses("$ComputerName")).IPAddressToString

#####################################################################
# Выбираем приоритетный IP для подключения. Начало

        $hashTable = $null

if ($ipaddressHost.count -gt 1) {

        $hashTable = @{}

For (

        [int]$numner = 0;
        $numner -lt $global:ipaddressHost.count;
        $numner = $numner + 1) {
                    
#####################################################################
        [string]$IP = $global:ipaddressHost[$numner]
        [int]$PrefixLength = $CIDR -replace '^[\d\.]+(\\|\/)',''
        [string]$Subnet = $CIDR -replace '(\\|\/)\d+$',''
        $SplitSubnetBin = $Subnet -split '\.' -match '\d' | % {[convert]::ToString($_,2).PadLeft(8,'0')}
        $SubnetBin = $SplitSubnetBin -join ''
        $SplitIPBin = $IP -split '\.' -match '\d' | % {[convert]::ToString($_,2).PadLeft(8,'0')}
        $IPBin = $SplitIPBin -join ''
        [bool]$Result = $true

for ($i = 0; $i -lt $PrefixLength; $i += 1) {
        
        [bool]$diff = [convert]::ToInt32(($SubnetBin[$i]),2) -eq [convert]::ToInt32(($IPBin[$i]),2)

if ($diff -eq $false) {

        $Result = $diff

}
}
 
        $hashTable.$IP = $Result

#####################################################################

}

For (   [int]$numner = 0;
        $numner -lt $global:ipaddressHost.count;
        $numner = $numner + 1 ) {

        $IPresult = $global:ipaddressHost[$numner]

if ($hashTable.$IPresult -like $True) {

        $global:ipaddressHost = $IPresult

}
}

if ($ipaddressHost.count -gt 1) {

        $number = Get-Random -Maximum (($ipaddressHost.count)-1) -Minimum 0
        $global:ipaddressHost = $global:ipaddressHost[$number]

}
}

# Выбираем приоритетный IP для подключения. Конец
##################################################################### 

}

# Проверка это имя компа или IP адрес. Конец  
#####################################################################

# Старт проверки доступности ПК по пинг, проверка доступности портов 445

	$global:fieldsinmain_log = ""
	$global:fields = ""
        $global:events_id = "39"
        MySQLWriteWithoutProgramName
        $TestComp = (Test-Connection -Count 2 -ComputerName $global:ipaddressHost -Quiet)

if ($TestComp -eq $true) {

	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "19"
        MySQLWriteWithoutProgramName

} else {           

        #$global:logSTring = "$ipaddressHost DO NOT ping ..... Ping may be prohibited"
        $global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "1"
        MySQLWriteWithoutProgramName
        Stop-Process -ID $PID -Force

}

        $SEL = TNC $global:ipaddressHost -Port 445 | Where-Object { $_.TcpTestSucceeded -like "True" } 

if ($SEL -ne $null) {

	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "20"
        MySQLWriteWithoutProgramName

} else {

	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "21"
        MySQLWriteWithoutProgramName
        Stop-Process -ID $PID -Force
}

        $testPathFolder = Test-Path \\$ipaddressHost\C$

if ($testPathFolder -eq 1) {

	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "31"
        MySQLWriteWithoutProgramName

} else {

	$global:fieldsinmain_log = ""
	$global:fields = ""
	$global:events_id = "32"
        MySQLWriteWithoutProgramName
        Stop-Process -ID $PID -Force
}

#####################################################################
# определяем имя ПК по IP адресу. Начало

if ((Test-Path \\$ipaddressHost\C$\Setup) -eq 0) {

        New-Item \\$ipaddressHost\C$\Setup -ItemType Directory

}



        $fileforcomputername = '$Comp_Name = $env:COMPUTERNAME
                                Export-Clixml -Path "C:\Setup\Comp_Name.cli" -Encoding UTF8 -InputObject $Comp_Name
                                Stop-Process -ID $PID -Force'
        $fileforcomputername | Out-File -Encoding UTF8 \\$ipaddressHost\C$\Setup\Comp_Name.ps1
        Start-Process -FilePath .\rest_api\config\bin\PsExec.exe -ArgumentList "-accepteula \\$ipaddressHost powershell -ExecutionPolicy Bypass -File C:\Setup\Comp_Name.ps1" -WindowStyle hidden

while ((Test-Path \\$ipaddressHost\c$\Setup\Comp_Name.cli) -eq 0) {

        Wait-Event -Timeout 1
        [int]$wait = 1
        $wait = $wait + 1
        
        if ($wait -eq 30) {
        
                $global:fieldsinmain_log = ""
                $global:fields = ""
                $global:events_id = "17"
                MySQLWriteWithoutProgramName
                   
        }
} 

if ((Test-Path \\$ipaddressHost\c$\Setup\Comp_Name.cli) -eq 1) {
            
        Remove-Item -Path "\\$ipaddressHost\c$\Setup\Comp_Name.ps1" -Force
        $global:logSTring = "Comp_Name.ps1 удален"
	$global:fieldsinmain_log = "script_id,"
	$global:fields = "5,"
	$global:events_id = "37"
        $global:ComputerName = Import-Clixml -Path "\\$ipaddressHost\c$\Setup\Comp_Name.cli"
        MySQLWriteWithoutProgramName

} else {

	$global:fieldsinmain_log = "script_id,"
	$global:fields = "5,"
	$global:events_id = "35"
        MySQLWriteWithoutProgramName

}

if ($ComputerName -ne $null) {

if ((Test-Path \\$ipaddressHost\c$\Setup\Comp_Name.cli) -eq 1) {

        Remove-Item -Path "\\$ipaddressHost\c$\Setup\Comp_Name.cli" -Force
	$global:fieldsinmain_log = "script_id,"
	$global:fields = "4,"
	$global:events_id = "37"
        MySQLWriteWithoutProgramName

} else {

	$global:fieldsinmain_log = "script_id,"
	$global:fields = "4,"
	$global:events_id = "34"
        MySQLWriteWithoutProgramName

}
}

# определяем имя ПК по IP адресу. Конец
#####################################################################
}