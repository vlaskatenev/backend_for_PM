$processAll = Get-WMiObject Win32_PerfFormattedData_PerfProc_Process |
        Select name, idProcess,
        @{n="ramUsage";e={[int]($_.WorkingSet/1mb)}},
        @{n="processorTimeUsage";e={[int]($_.PercentProcessorTime)}} | ConvertTo-Json

# средняя загрузка CPU и RAM
$averageCpu = (Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average

$averageRam = (Get-Counter '\память\% использования выделенной памяти').CounterSamples.CookedValue


## Формируем JSON
$Info = @"
{
   "averageCpu": $averageCpu,
   "averageRam": $averageRam,
   "data": $processAll
}
"@
Write-Output $Info