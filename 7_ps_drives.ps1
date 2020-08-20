# List all
Get-PSDrive

# Zertifikate
cd Cert:
set-location cert:
set-location cert:currentuser

# Anlegen eines PS-Drives
New-PSDrive -Name Desktop -PSProvider FileSystem -Root "C:\Users\Administrator\Desktop"


