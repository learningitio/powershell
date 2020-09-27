# Start von Transscript
start-transcript
# Script
write-host "test"
# Beenden von Transcript
stop-transcript


# Bevorzugte Settings:
# Test, ob Ordner vorhanden..falls nicht, erzeuge den Ordner
if (!(test-path ".\logs")) {
    mkdir ".\logs"
}
# String erstellen, um Pfad und Namen für die Logs zu speichern
[string]$transcriptfile = (".\logs\."+(get-date -format "yyyy-MM-dd-HH-mm-ss-fff")+".log")

# Starten des Transcript mit vorher definiertem Zielpfad
Start-Transcript -path $transcriptfile




# Erstellen einer Funktion, welche obige Configurationen zusammenfast
function Transcript {
    if (!(test-path ".\logs")) {
        mkdir ".\logs"
    }
    [string]$transcriptfile = (".\logs\WFMReporting."+(get-date -format "yyyy-MM-dd-HH-mm-ss-fff")+".log")
    write-output "Start Transcript to " $transcriptfile 
    Start-Transcript -path $transcriptfile
}


# Transcipt bei älteren Versionen kein Write-Host!
 
