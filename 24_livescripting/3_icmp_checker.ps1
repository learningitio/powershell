# Import der Quelldatei
$import = (Import-Csv "C:\Code\powershell\24_livescripting\hostips.csv").Host

# Check der Quell-Hosts / Quell-IPs
$reachable = @()
$unreachable = @()

foreach ($one in $import){
    if(Test-Connection $one -Count 1 -Quiet){
        write-host "$one" -ForegroundColor Green
        $reachable += $one
    }

    else {
        write-host "$one" -ForegroundColor Red
        $unreachable += $one
    }
}


