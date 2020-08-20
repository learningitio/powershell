Get-acl "C:\Filesystem1.txt"
get-acl "C:\Filesystem1.txt" | set-acl "C:\Filesystem2.txt"


# Konkretes Anpassen:

$acl = Get-Acl "C:\Filesystem1.txt"
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("ENTERPRISE\T.Simpson","FullControl","Allow")

$acl.SetAccessRule($AccessRule)

$acl | Set-Acl \\fs1\shared\sales