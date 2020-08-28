# Set Location to C:
Set-Location "C:\"

# Receive all empty directories
Get-ChildItem -Directory -Recurse | Where-Object {($_.GetFiles().Count -eq 0) -and $_.GetDirectories().Count -eq 0} | Select-Object -ExpandProperty FullName