# Job starten
start-job -scriptblock {
    write-host "hello"
    start-sleep -seconds 10
}

# Jobs auflisten
get-job

# Job-Output auslesen
receive-job 2

# -> Jobs im Hintergrund laufen lassen, um zu einem späteren Zeitpunk den Output abzufragen



# Multithreading mit PS7 für ForEach
$ip = @()
$ip += "8.8.8.8"
$ip += "8.8.4.4"
$ip += "localhost"

# Parallele Ausfürhung ohne Limit
$ip | foreach-object -parallel  {
    test-connection $_
} 

# Parallele Ausfürhung mit Limit (2 gleichzeitig)
$ip | foreach-object -parallel  {
    test-connection $_
}  -throttlelimit 2

# Vergleich von Sequentieller Durchfürhung / Paralleler Durchführung
# Seq
measure-command -expression {
    $ip | foreach-object  {
        test-connection $_
    } 
}

# Par 
measure-command -expression {
    $ip | foreach-object -parallel  {
        test-connection $_
    } 
}