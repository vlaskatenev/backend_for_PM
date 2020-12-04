Import-Module .\installSoftScripts\simpleFunctions

# функция проверет установлен ли софт
# и если не установлен то проверяет по $processId запущен ли процесс на компьютере
function checkInstallingSoft {
    # checkInstallingSoft -softDisplayName $softDisplayName -processId $processId
    Param (
        [String]$softDisplayName,
        $processId
        )

    if (findDisplayNameInReg -softDisplayName $softDisplayName) {
        # софт уже установлен
        logsWrite -logString "$softDisplayName soft have on client"
        return "soft have on client"
    } else {
        # проверка запущен ли установщик
        if (Get-Process -Id $processId -ErrorAction SilentlyContinue) {
            logsWrite -logString "$softDisplayName process finded - PID = $processId"
            return $processId
        }
        logsWrite -logString "$softDisplayName process not finded"
        return "process not finded"
    }
}


function findDisplayNameInReg {
    # findDisplayNameInReg -softDisplayName "Google Chrome"
    param (
        [String]$softDisplayName
    )

    $Reg = @( "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" )
    $InstalledApps = Get-ItemProperty $Reg -EA 0
    $WantedApp = $InstalledApps | Where { $_.DisplayName -like $softDisplayName }
    
    if ($WantedApp) { 
        logsWrite -logString "$softDisplayName finded on client, $WantedApp"
        return $true 
    } else { 
        logsWrite -logString "$softDisplayName NOT finded on client"
        return $false 
    }
}
