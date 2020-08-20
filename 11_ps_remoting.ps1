# Requirements:
# PS-Remoting Enabled
# DomainAdmin oder in RemoteGruppe
# (WinRM Trusted Hosts)

Enable-PSRemoting

# verwalteter Server
winrm set winrm/config/client @{TrustedHosts="Server01"}

# zu verwaltender Server
# winrs -r:Server02 cmd.exe

# Enter-PSSession
Enter-PSSession Server01
hostname
Exit-PSSession


# Invoke-Command
Invoke-Command -ComputerName Server01 -ScriptBlock {
    $a = 1
    write-host "$a"
}

# Einschub: Scope Variablen
Write-Host "Source: $a"

# Proof, dass separate Session
Invoke-Command -ComputerName Server01 -ScriptBlock {
    Write-Host "$a"
}

# Invoke-Command in einer Session
$session = New-PSSession -ComputerName Server01
Invoke-Command -Session $session -ScriptBlock {
    $a = 1
    write-host "$a"
}

Invoke-Command -Session $session -ScriptBlock {
    write-host "$a"
}