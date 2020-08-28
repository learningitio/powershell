# Receiving enabled Firewall Rules - inbound and outbound
[string]$inbound = Get-NetFirewallRule -Enabled True -Direction Inbound -Action Allow | Select-Object DisplayName | Out-String
[string]$outbound = Get-NetFirewallRule -Enabled True -Direction Outbound -Action Allow | Select-Object DisplayName | Out-String

# Get TimeStamp
[string]$time = Get-Date

# Log Message
[string]$log = "Firewall Rules at $time" + "`n" + "Inbound-Rules:" + "`n" + $inbound + "`n" + "Outbound-Rules:" + "`n" + $inbound + "EOF"



$log | Out-File -FilePath "C:\firewall.log" -Append