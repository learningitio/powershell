<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$network_scanner                 = New-Object system.Windows.Forms.Form
$network_scanner.ClientSize      = New-Object System.Drawing.Point(327,418)
$network_scanner.text            = "Network Scanner"
$network_scanner.TopMost         = $false

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 119
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(9,33)
$TextBox1.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ComboBox1                       = New-Object system.Windows.Forms.ComboBox
$ComboBox1.text                  = "  SN"
$ComboBox1.width                 = 56
$ComboBox1.height                = 20
@('/8','/16','/32') | ForEach-Object {[void] $ComboBox1.Items.Add($_)}
$ComboBox1.location              = New-Object System.Drawing.Point(146,33)
$ComboBox1.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$GetactiveIPs                    = New-Object system.Windows.Forms.Button
$GetactiveIPs.text               = "Get Active IPs"
$GetactiveIPs.width              = 92
$GetactiveIPs.height             = 30
$GetactiveIPs.location           = New-Object System.Drawing.Point(219,27)
$GetactiveIPs.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$DataGridView1                   = New-Object system.Windows.Forms.DataGridView
$DataGridView1.width             = 300
$DataGridView1.height            = 337
$DataGridView1.location          = New-Object System.Drawing.Point(9,67)

$network_scanner.controls.AddRange(@($TextBox1,$ComboBox1,$GetactiveIPs,$DataGridView1))




#Write your logic code here

[void]$network_scanner.ShowDialog()