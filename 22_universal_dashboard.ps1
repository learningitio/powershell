# First Start
Install-Module UniversalDashboard.Community 
Import-Module UniversalDashboard.Community

$theme = Get-UDTheme -Name 'Azure'
$dashboard = New-UDDashboard -Title "Learning IT" -theme $theme -Content{
    New-UDHeading -Text "LearningIT"

    New-UDRow {

        New-UDColumn -Size 3 {

            New-UDMonitor -Title "CPU" -Type Line -DataPointHistory 20 -RefreshInterval 10 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
            (get-childitem -Path "C:\Users\Administrator\Documents\Powershell Expertenkurs\logs").count | Out-UDMonitorData

            }           
        }

        New-UDColumn -Size 3 {
            New-UDChart -Title "Threads by Process" -Type Doughnut -RefreshInterval 5 -Endpoint {  
                Get-Process | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
            } -Options @{  
                 legend = @{  
                     display = $false  
                 }  
               }
        }

    }
}

Start-UDDashboard -Dashboard $dashboard -Port 10097