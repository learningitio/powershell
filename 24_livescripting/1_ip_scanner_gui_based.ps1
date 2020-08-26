<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$network_scanner                 = New-Object system.Windows.Forms.Form
$network_scanner.ClientSize      = New-Object System.Drawing.Point(291,422)
$network_scanner.text            = "Network Scanner"
$network_scanner.TopMost         = $false

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 119
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(9,33)
$TextBox1.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$GetactiveIPs                    = New-Object system.Windows.Forms.Button
$GetactiveIPs.text               = "Get Active IPs"
$GetactiveIPs.width              = 118
$GetactiveIPs.height             = 30
$GetactiveIPs.location           = New-Object System.Drawing.Point(139,27)
$GetactiveIPs.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$GetactiveIPs.add_Click({PingAndGridOut $TextBox1.Text})

$DataGridView1                   = New-Object system.Windows.Forms.DataGridView
$DataGridView1.width             = 267
$DataGridView1.height            = 337
$DataGridView1.location          = New-Object System.Drawing.Point(6,68)
$dataGridView1.ColumnCount       = 1


$Debugging                       = New-Object system.Windows.Forms.TextBox
$Debugging.multiline             = $false
$Debugging.width                 = 118
$Debugging.height                = 20
$Debugging.location              = New-Object System.Drawing.Point(9,8)
$Debugging.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$network_scanner.controls.AddRange(@($TextBox1,$GetactiveIPs,$DataGridView1,$Debugging))




#Write your logic code here

[void]$network_scanner.ShowDialog()





#Write your logic code here

function PingAndGridOut {
    param (
        [string]$IP
    )

    $ip_formatted = $IP.Split(".")
    $okt1 = $ip_formatted[0]
    $okt2 = $ip_formatted[1]
    $okt3 = $ip_formatted[2]


    for ($i = 1; $i -lt 255; $i++){
        write-host "$i"
        $ip_new = $okt1 + "." + $okt2 + "." + $okt3 + "." + $i
        Write-Host "$ip_new"
        if (Test-Connection $ip_new -count 1 -quiet){
            write-host "$ip_new available"
            $DataGridView1.Rows.Add($ip_new)

        }
        

        

    }

    
}



[void]$network_scanner.ShowDialog()