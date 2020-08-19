# Methode 1 - nicht empfehlenswert

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

# ABER
$password = ConvertTo-SecureString 'P@ssw0rd' -AsPlainText -Force
$Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($password)
$result 



# Methode 2 - Powershell SecretManagement
Install-Module -Name Microsoft.PowerShell.SecretsManagement -AllowPrerelease

Get-SecretVault
Get-SecretInfo

Set-Secret -Name "NAME" -SecureStringSecret "SECRET"
Get-Secret -Name "NAME"