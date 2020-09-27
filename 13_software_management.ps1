# Installierte Programme auslesen
Get-CimInstance -class Win32_Product 
Get-CimInstance -class Win32_Product -Property *

# Install (ohne CIM)
Start-Process "C:\vlc-3.0.4-win64.msi" -ArgumentList '/quiet' -Wait

# Uninstall
Get-CimInstance -Class Win32_Product | Where-Object {$_.Name -like "*VLC*"} | Invoke-CimMethod -MethodName Uninstall

# Install CIM
Invoke-CimMethod -Class Win32_Product -MethodName Install -Arguments @{PackageLocation='C:\vlc-3.0.4-win64.msi'}

# Upgrade
Invoke-CimMethod -Class Win32_Product -MethodName Upgrade -Arguments @{PackageLocation='C:\vlc-3.0.4-win64.msi'} 