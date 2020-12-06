# загрузка основного архива и распаковка
$url="http://127.0.0.1:8081/scripts/installSoftScripts.zip"
$pathToDownload = "C:\Setup\installSoftScripts.zip"
Start-BitsTransfer –source  $url -destination $pathToDownload -Priority low
Expand-Archive $pathToDownload -DestinationPath C:\Setup\

# загрузка скрипта со списком программ и ключами для установки
$compname = (Get-WmiObject -Class Win32_ComputerSystem).Name
$url="http://127.0.0.1:8081/scripts/forClients/$compname.ps1"
$pathToDownload = "C:\Setup\installSoftScripts\programmVariables.ps1"
Start-BitsTransfer –source  $url -destination $pathToDownload -Priority low

Set-Location -Path C:\Setup\installSoftScripts
Start-Process -FilePath powershell -ArgumentList "-ExecutionPolicy Bypass -File C:\Setup\installSoftScripts\_startInstall.ps1" -WindowStyle hidden
