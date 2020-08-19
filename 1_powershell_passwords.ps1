# Methode 1 - nicht empfehlenswert

# Anlegen der Creds und Export
$user = Read-Host "Enter Username"
$pass = Read-Host "Enter Password" -AsSecureString | ConvertFrom-SecureString | Out-File "C:\pass.txt"

# Import und Convert2Secure
$pass = Get-Content "C:\pass.txt" | ConvertTo-SecureString