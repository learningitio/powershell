# Simple Array
$array = @()
$array += "test1"
$array += "test2"

# Change Array Entries
$array[0] = "test"

# Array auf Inhalt prüfen
$array -contains "test"

# Bestimmten Array Eintrag ausgeben
$array -eq "test"

# Array bestimmten Inhalt ausgeben
$array -eq "negotiation"

# Arrays "addieren"
$array2 = @()
$array2 += "test3"
$array3 = $array2 + $array

# Verschiedene Datentypen
[int]$zahl = 5
$array += $zahl
($array[1]).GetType()
($array[2]).GetType()

# Strongly Typed
[int32[]]$array_Strong = @()
$array_Strong += "test"
$array_Strong += 5

# Nested Arrays
# Nested
$nested = @(
    @(1,2,3),
    @(4,5,6),
    @(7,8,9)
)

$nested[1][1]


# Array erstellen
$eigenesArray = @()
$server = hostname
$disk = (get-disk).count
$object = New-Object psobject
$object | Add-Member NoteProperty Server $server 
$object | Add-Member NoteProperty DiskCount $disk
$eigenesArray += $object


# ArrayAnzeige
$eigenesArray
$eigenesArray.DiskCount

