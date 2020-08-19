# Aktuelle Policy auslesen
Get-ExecutionPolicy

# ExecutionPolicy setzen: unrestricted, allsigned, remotesigned, restricted, unrestricted
Set-ExecutionPolicy Unrestricted


# Scripte Signen
# Funktioniert noch nicht mit PowerShell Core.

#SelfSigned Codesigning anlegen
$cert = New-SelfSignedCertificate `
                   -DnsName codesign.learning-it.io `
                   -Type CodeSigning `
                   -CertStoreLocation Cert:\CurrentUser\My


# Kennwort
$CertPassword = ConvertTo-SecureString `
                   -String "Test" `
                   -Force `
                   –AsPlainText

# Zertifikat exportieren
Export-PfxCertificate `
   -Cert "Cert:\CurrentUser\My\$($cert.Thumbprint)" `
   -Password $CertPassword `
   -FilePath "C:\test.pfx"

# Script musss nun noch zu den Trusted Root Publishern gepackt werden

# Informationen über das erste Codesigning-Zertifikat aus meinem Store laden
$signingcert =(dir Cert:\CurrentUser\My -CodeSigningCert)[0]

#Signieren eines Skript im aktuellen Verzeicnis
Set-AuthenticodeSignature "C:\Code\test.ps1" -Certificate $signingcert