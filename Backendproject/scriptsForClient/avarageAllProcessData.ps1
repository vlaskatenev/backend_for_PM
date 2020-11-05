$processAll = Get-WMiObject Win32_PerfFormattedData_PerfProc_Process |
        Select name, idProcess,
        @{n="ramUsage";e={[int]($_.WorkingSet/1mb)}},
        @{n="processorTimeUsage";e={[int]($_.PercentProcessorTime)}} | ConvertTo-Json

# средняя загрузка CPU и RAM
$averageCpu = (Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average

$averageRam = (Get-Counter '\память\% использования выделенной памяти').CounterSamples.CookedValue

$averageDiskAll = (Get-WmiObject -Class Win32_perfformatteddata_perfdisk_LogicalDisk |
                   Select-Object Name,DiskReadBytesPersec,DiskWriteBytesPersec) |
                   Where-Object {$_.Name -eq "_Total"}
$averageDisk = ($averageDiskAll.DiskReadBytesPersec + $averageDiskAll.DiskWriteBytesPersec) / 1MB

ForEach ($counter in @((Get-NetAdapter).DriverDescription)) {
    if (@(((Get-Counter).CounterSamples).InstanceName) -contains $counter) {
        $networkAdapterSpeed = (Get-Counter "\сетевой интерфейс($counter)\всего байт/с").CounterSamples.CookedValue
        $fullyNetworkSpeed += $networkAdapterSpeed
    }
}

## Формируем JSON
$Info = @"
{
   "averageCpu": $averageCpu,
   "averageRam": $averageRam,
   "averageDisc": $averageDisk,
   "fullyNetworkSpeed": $fullyNetworkSpeed,
   "detailProcessData": $processAll
}
"@


Write-Output $Info