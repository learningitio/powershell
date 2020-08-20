# Job starten
start-job -scriptblock {
    write-host "hello"
    start-sleep -seconds 10
}

# Alternativ für kurze Tasks (zB API-Call)
get-eventlog -Logname System -Job

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

$ip | foreach-object -parallel  {
    test-connection $_
} # -throttlelimit 2


# Proof

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