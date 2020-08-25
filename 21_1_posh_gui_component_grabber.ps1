<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$component_grabber               = New-Object system.Windows.Forms.Form
$component_grabber.ClientSize    = New-Object System.Drawing.Point(203,81)
$component_grabber.text          = "IP Grabber "
$component_grabber.TopMost       = $false

$PictureBox1                     = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width               = 67
$PictureBox1.height              = 66
$PictureBox1.location            = New-Object System.Drawing.Point(118,9)
$PictureBox1.imageLocation       = "https://learning-it.io/wp-content/uploads/2020/05/cropped-rsz_logo_1-01-2.jpg"
$PictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 93
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(13,13)
$TextBox1.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Grab that IP!"
$Button1.width                   = 92
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(14,41)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Button1.add_click({GetIP})

$component_grabber.controls.AddRange(@($PictureBox1,$TextBox1,$Button1))




#Write your logic code here

function GetIP {
    $TextBox1.Text = (Get-NetIPAddress -AddressFamily ipv4 -InterfaceAlias Ethernet | Select-Object IPAddress).IPAddress
}


[void]$component_grabber.ShowDialog()