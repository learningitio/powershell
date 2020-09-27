# ACL von einem File/Directory auf anderes Objekt anwenden:
Get-Acl C:\Users\Philip.SERVER01\Desktop\txt1.txt | select *
Get-Acl C:\Users\Philip.SERVER01\Desktop\txt1.txt | Set-Acl "C:\Users\Philip.SERVER01\Desktop\txt2.txt"

# ACL von spezifischemn File anpassen:

# Import der ACL
$acl = Get-Acl "C:\Users\Philip.SERVER01\Desktop\txt1.txt"
# Erstellen eines ACL-Eintrags
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Server01\Guest","FullControl","Allow")
# Zuweisen des Eintrags zur importierten ACL
$acl.SetAccessRule($AccessRule)
# Anwenden der modifizierten ACL
$acl | Set-Acl "C:\Users\Philip.SERVER01\Desktop\txt1.txt"