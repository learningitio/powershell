$dashboard = New-UDDashboard -Title "Learning IT" -Content{
    New-UDHeading -Text "LearningIT"
}

Start-UDDashboard -Dashboard $dashboard -Port 1000 -AutoReload