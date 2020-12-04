
function findDisplayNameInReg {
    param (
        [String]$softDisplayName
    )

    $Reg = @( "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" )
    $InstalledApps = Get-ItemProperty $Reg -EA 0
    $WantedApp = $InstalledApps | Where { $_.DisplayName -like $softDisplayName }
    
    if ($WantedApp) { return $true } else { return $false }
}

