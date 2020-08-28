<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$RemoteGrabber                   = New-Object system.Windows.Forms.Form
$RemoteGrabber.ClientSize        = New-Object System.Drawing.Point(422,230)
$RemoteGrabber.text              = "RemoteGrabber0.1"
$RemoteGrabber.TopMost           = $false

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Enter Hostname here:"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(18,20)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TextBoxInput                    = New-Object system.Windows.Forms.TextBox
$TextBoxInput.multiline          = $false
$TextBoxInput.width              = 113
$TextBoxInput.height             = 20
$TextBoxInput.location           = New-Object System.Drawing.Point(163,15)
$TextBoxInput.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Get Information"
$Button1.width                   = 107
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(299,9)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Button1.add_Click({Grab $TextBoxInput.Text})

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "IP-Address"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(17,62)
$Label2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ProgressBar1                    = New-Object system.Windows.Forms.ProgressBar
$ProgressBar1.width              = 279
$ProgressBar1.height             = 27
$ProgressBar1.location           = New-Object System.Drawing.Point(54,193)
$ProgressBar1.Maximum            = 3
$progressbar1.Step               = 1
$progressbar1.Value              = 0

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "RAM"
$Label3.AutoSize                 = $true
$Label3.width                    = 25
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(17,89)
$Label3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label4                          = New-Object system.Windows.Forms.Label
$Label4.text                     = "CPU"
$Label4.AutoSize                 = $true
$Label4.width                    = 25
$Label4.height                   = 10
$Label4.location                 = New-Object System.Drawing.Point(17,116)
$Label4.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TextBoxIP                       = New-Object system.Windows.Forms.TextBox
$TextBoxIP.multiline             = $false
$TextBoxIP.width                 = 110
$TextBoxIP.height                = 20
$TextBoxIP.location              = New-Object System.Drawing.Point(163,53)
$TextBoxIP.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TextBoxRAM                      = New-Object system.Windows.Forms.TextBox
$TextBoxRAM.multiline            = $false
$TextBoxRAM.width                = 111
$TextBoxRAM.height               = 20
$TextBoxRAM.location             = New-Object System.Drawing.Point(162,82)
$TextBoxRAM.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TextBoxCPU                      = New-Object system.Windows.Forms.TextBox
$TextBoxCPU.multiline            = $false
$TextBoxCPU.width                = 110
$TextBoxCPU.height               = 20
$TextBoxCPU.location             = New-Object System.Drawing.Point(163,109)
$TextBoxCPU.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10)


$PictureBox1                     = New-Object system.Windows.Forms.PictureBox
$PictureBox1.width               = 104
$PictureBox1.height              = 94
$PictureBox1.location            = New-Object System.Drawing.Point(300,59)
$PictureBox1.imageLocation       = "https://learning-it.io/wp-content/uploads/2020/05/cropped-rsz_logo_1-01-2.jpg"
$PictureBox1.SizeMode            = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$RemoteGrabber.controls.AddRange(@($Label1,$TextBoxInput,$Button1,$Label2,$ProgressBar1,$Label3,$Label4,$Label5,$TextBoxIP,$TextBoxRAM,$TextBoxCPU,$PictureBox1))




#Write your logic code here

function Grab {
    param (
        [string]$hostparam
    )

    # Get IP
    $ip = (Test-Connection $hostparam -Count 1).IPV4Address.IPAddressToString
    $TextBoxIP.Text = $ip
    $ProgressBar1.PerformStep()

    # Get RAM
    $ram = [math]::Round(((Get-WmiObject -Class Win32_ComputerSystem -ComputerName $hostparam).TotalPhysicalMemory) / (1073741824),2)
    $TextBoxRAM.text = $ram
    $ProgressBar1.PerformStep()

    # Get CPU
    $cpu = (Get-WmiObject -Class win32_processor -ComputerName $hostparam).Name
    $TextBoxCPU.Text = $cpu
    $ProgressBar1.PerformStep()
    
}

[void]$RemoteGrabber.ShowDialog()

