# Switch 2 Windows Shell
Get-EventLog -LogName System
Get-EventLog -LogName System | select *
Get-EventLog -LogName System | Where-Object {$_.EventID -eq 7036}


# Remote
Get-EventLog -ComputerName Server01 -LogName System

# Type
Get-EventLog -EntryType Error -LogName System

# Newest
Get-EventLog -Newest 10 -LogName System

# Time
$time = (Get-Date).AddDays(-5)
Get-EventLog -After $time -LogName System