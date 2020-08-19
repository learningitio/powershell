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


# Ändern von Einträgen
$array = @()
$array += 1
$array += 2

$array
$array[0]
$array[0] = 2
$array


# Arrays addieren
$eigenesArray + $array # Schwachsinn

$array2 = @()
$array2 += 3
$array2 += 4

$array3 = $array + $array2


# Funktionen von Arrays

- contains
- eq
- ne 


# Typing
[Int[]]$array_new = @()
$array_new += 1
$array_new += "test"


# Nested
$nested = @(
    @(1,2,3),
    @(4,5,6),
    @(7,8,9)
)

$nested[1][1]