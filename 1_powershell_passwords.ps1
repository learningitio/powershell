# Methode 1 - nicht empfehlenswert (Da die Hashes geknackt werden könnten), aber noch häufig im Einsatz

# Anlegen der Creds und Export
$user = Read-Host "Enter Username"
$pass = Read-Host "Enter Password" -AsSecureString | ConvertFrom-SecureString | Out-File "C:\pass.txt"

# Import und Convert2Secure
$pass = Get-Content "C:\pass.txt" | ConvertTo-SecureString

# Generieren CredentialObject
$user = Read-Host "Enter Username"
$File = "C:\pass.txt"
$MyCredential = New-Object -TypeName System.Management.Automation.PSCredential `
 -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)

# Methode 2 - Powershell SecretManagement
Install-Module -Name Microsoft.PowerShell.SecretsManagement -AllowPrerelease

Get-SecretVault
Get-SecretInfo

Set-Secret -Name "NAME" -SecureStringSecret "SECRET"
Get-Secret -Name "NAME"