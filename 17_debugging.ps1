# Inahltlich irrelevant - lediglich Beispielsscript für Debugging

# Allgemein: Strict typing!
$zahl = read-host "Gib eine Zahl deiner Wahl ein"
$zahl + 5

[int]$zahl = read-host "Gib eine Zahl deiner Wahl ein"
$zahl + 5


# Write-Host Debugging
$zahl = 12
$zahl = $zahl + 4
$zahl2 = $zahl
$zahl + 6 + $zahl2


$zahl = 12
Write-Host "Zeile 11: $zahl"
$zahl = $zahl + 4
Write-Host "Zeile 13: $zahl"
$zahl2 = $zahl
Write-Host "Zeile 15: $zahl"
$zahl + 6 + $zahl2

# Transcipt bei älteren Versionen kein Write-Host!

write-error "test"
write-warning "test"


# Debuggin mit VSCode
function DebuggingTest {
    $zahl = 5
    $zahl = $zahl * 4
    $zahl = $zahl / 12
    
}