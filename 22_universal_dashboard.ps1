Install-Module UniversalDashboard.Community -AcceptLicense

# https://dev.to/jcoelho/powershell-universal-dashboard-making-interactive-dashboards-9kl

# https://docs.universaldashboard.io/getting-started


# First Start
Install-Module UniversalDashboard.Community -AcceptLicense
Import-Module UniversalDashboard.Community

# Theme change

# Monitoring

# Charts



# dashboard:

# First Start
Install-Module UniversalDashboard.Community 
Import-Module UniversalDashboard.Community

$theme = Get-UDTheme -Name 'Azure'
$dashboard = New-UDDashboard -Title "Learning IT" -Content{
    New-UDHeading -Text "LearningIT"

    New-UDRow {
            New-UDColumn -Size 3 {
    New-UDMonitor -Title "CPU" -Type Line -DataPointHistory 20 -RefreshInterval 10 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {

        (get-childitem).count | Out-UDMonitorData

    }            }
            New-UDColumn -Size 3 {


                        New-UDChart -Title "Disk Space" -Type Doughnut -RefreshInterval 10 -Endpoint {  
            try {
                Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object {$_.DriveType -eq '3'} | Select-Object -First 1 -Property DeviceID,Size,FreeSpace | ForEach-Object {
                    @([PSCustomObject]@{
                        Label = "Used Space"
                        Data = [Math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2);
                    },
                    [PSCustomObject]@{
                        Label = "Free Space"
                        Data = [Math]::Round($_.FreeSpace / 1GB, 2);
                    }) | Out-UDChartData -DataProperty "Data" -LabelProperty "Label" -BackgroundColor @("#80FF6B63","#8028E842") -HoverBackgroundColor @("#80FF6B63","#8028E842") -BorderColor @("#80FF6B63","#8028E842") -HoverBorderColor @("#F2675F","#68e87a")
                }
            }
            catch {
                0 | Out-UDChartData -DataProperty "Data" -LabelProperty "Label"
            }
        }



                } 
            }

}

Start-UDDashboard -Dashboard $dashboard -Port 10095