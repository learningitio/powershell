# Array für CSV-Export
$eigenesArray = @()
$server = hostname
$disk = (get-disk).count
$object = New-Object psobject
$object | Add-Member NoteProperty Server $server 
$object | Add-Member NoteProperty DiskCount $disk
$eigenesArray += $object

# CSV Export
$eigenesArray | export-csv -path C:\test.csv -delimiter ";"
get-process | export-csv -path C:\test2.csv -delimiter ";"


# CSV Import
$csv = import-csv -path C:\test2.csv -delimiter ";"