function Test-Port {
    # Reading Host-Name/IP from User
    $computer = Read-Host "Computername | IP Address?"

    # User Choice of Check-Method
    $single = New-Object System.Management.Automation.Host.ChoiceDescription '&Single', 'Testing a single Port'
    $multi = New-Object System.Management.Automation.Host.ChoiceDescription '&Multi', 'Testing Multiple Ports - Comma-Separated'
    $range = New-Object System.Management.Automation.Host.ChoiceDescription '&Range', 'Testing Port Range - Separated with !'
    
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($single, $multi, $range)

    $title = 'Port Choice'
    $message = 'Select Check-Method:'
    $result = $host.ui.PromptForChoice($title, $message, $options, 0)

    # PortCheck (depending on User-Choice)
    switch ($result) {
        # Performing Method "Single"
        0 {
            $prompt = read-host "Please Enter Single Port"
            If ((Test-NetConnection $computer -Port $prompt -WarningAction SilentlyContinue).tcpTestSucceeded -eq $true) {
                Write-Host $computer $prompt -ForegroundColor Green -Separator " ==> "
            } 
            else {
                Write-Host $computer $prompt -ForegroundColor Red -Separator " ==> "
            }
         }
        
        # Performing Method "Multi"
        1 {
            $prompt = read-host "Please Enter Comma-Separated Ports"
            $ports = $prompt.Split(",")

            foreach ($element in $ports){
                If ((Test-NetConnection $computer -Port $element -WarningAction SilentlyContinue).tcpTestSucceeded -eq $true) {
                    Write-Host $computer $element -ForegroundColor Green -Separator " ==> "
                } 
                else {
                    Write-Host $computer $element -ForegroundColor Red -Separator " ==> "
                } 
            }
         }

        # Performing Method "Range" 
        2 { 
            $prompt = read-host "Please Enter !-Separated Ports"
            $ports = $prompt.Split("!")

            $first = $ports[0]
            $last = $ports[1]
            $portlist = $first..$last

            foreach ($element in $portlist){
                If ((Test-NetConnection $computer -Port $element -WarningAction SilentlyContinue).tcpTestSucceeded -eq $true) {
                    Write-Host $computer $element -ForegroundColor Green -Separator " ==> "
                } 
                else {
                    Write-Host $computer $element -ForegroundColor Red -Separator " ==> "
                } 
            }
         }
    }

}