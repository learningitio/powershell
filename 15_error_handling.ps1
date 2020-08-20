# Powershell Standards
$ErrorActionPreference

# SilentlyContinue
# Continue
# Inquire
# Stop

<#
SilentlyContinue: Die Fehlermeldung wird unterdrückt und PowerShell fährt mit der Ausführung des Codes fort
Ignore (seit Version 3): Der Fehler wird ignoriert und taucht nicht im Error-Stream auf.
Continue: Dabei handelt es sich um das Standard­verhalten. Fehler­meldungen werden (in roter Schrift) ausgegeben und das Script setzt seine Ausführung fort.
Stop: Erzwingt ein Verhalten wie bei einem terminierenden Fehler, die Ausführung wird also abgebrochen.
Inquire: Fragt den Benutzer, ob er die Ausführung fortsetzen möchte.
#>





# Error Var
$Error
$error.Count
$error.clear()

# Try Catch

try {
    write-host "Hier wird was versucht, was schief gehen kann"
    $a = 1/0
}
catch {
    write-host "Fehler abgefangen: $_.Exception.Message"
 
}
finally {
     write-host "Finalize wird immer ausgeführt"
}
 # Der Fehler wird zusaetzlich auch in $error hinterlegt
 write-host $Error
 

 # Defensiver Stil bevorzugt!
