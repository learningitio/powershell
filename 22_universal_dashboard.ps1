Install-Module UniversalDashboard.Community -AcceptLicense

# https://dev.to/jcoelho/powershell-universal-dashboard-making-interactive-dashboards-9kl


$theme = Get-UDTheme -Name 'Azure'
$dashboard = New-UDDashboard -Title "LearningIT" -theme $theme -Content{
    New-UDHeading -Text "Powershell is Fun!!"
}

Start-UDDashboard -Dashboard $dashboard -Port 1000 -AutoReloadY
