# Get installed Products
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table –AutoSize > C:\installedapps.txt

# Compare List with List from another computer
Compare-Object -ReferenceObject (Get-Content "") -DifferenceObject (Get-Content "")