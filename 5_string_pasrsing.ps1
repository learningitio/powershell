$string = "Ich heiße Philip und betreibe LearningIT"

# Split
$string.split(" ")
$array = $string.split(" ")
$anfangswert = $array[0]

# Replace
$string.Replace("Philip", "Tom")

# Remove
$string.Remove(1,5)

# Lenght
$string.Lenght




#######




$eigenesarray = @()
$server = hostname
$disk = (Get-Disk).count
$object = New-Object psobject
$object | Add-Member NoteProperty Server $server
$object | Add-Member NoteProperty DiskCount $disk
$eigenesarray += $object

$eigenesarray | Export-Csv -Path "C:\Code\csv.csv" -Delimiter ";"


Get-ChildItem | Export-Csv -Path "C:\Code\gci.csv" -Delimiter ";"


$import = import-csv -Path "C:\Code\gci.csv" -Delimiter ";"  | sort LastWriteTime | select FullName, LastWriteTime | where {$_.FullName -eq "C:\Code\arrays.ps1"}
