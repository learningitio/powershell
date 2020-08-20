# Private, Local, Script und Global

#Private: Im unteren Bereich nicht ansprechbar
#Local: Standard
#Script: Vars aus Funktion auch im Script
#Global: Überall



$outervalue = 1

function TestFunction {   
    $Script:innervalue = 2
    $outervalue = 2

    write-host "$innervalue" -ForegroundColor Green
    write-host "$outervalue" -ForegroundColor Green
}

TestFunction

write-host "$innervalue" -ForegroundColor Red
write-host "$outervalue" -ForegroundColor Red




$outervalue = 1

function TestFunction {   
    $innervalue = 2
    $outervalue = 2

    write-host "$innervalue" -ForegroundColor Green
    write-host "$outervalue" -ForegroundColor Green
}

TestFunction

write-host "$innervalue" -ForegroundColor Red
write-host "$outervalue" -ForegroundColor Red




