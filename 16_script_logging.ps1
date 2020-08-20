start-transcript
write-host "test"
stop-transcript


if (!(test-path ".\logs")) {
    mkdir ".\logs"
}
[string]$transcriptfile = (".\logs\WFMReporting."+(get-date -format "yyyy-MM-dd-HH-mm-ss-fff")+".log")
write-output "Start Transcript to " $transcriptfile 
Start-Transcript -path $transcriptfile




# As a function
function Transcript {
    if (!(test-path ".\logs")) {
        mkdir ".\logs"
    }
    [string]$transcriptfile = (".\logs\WFMReporting."+(get-date -format "yyyy-MM-dd-HH-mm-ss-fff")+".log")
    write-output "Start Transcript to " $transcriptfile 
    Start-Transcript -path $transcriptfile
}


