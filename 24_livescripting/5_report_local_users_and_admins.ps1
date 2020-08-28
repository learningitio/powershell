# Receiving all users from the system
$users = Get-Localuser | Select-Object Name, PasswordRequired, Enabled, LastLogon

# Get Admins from AdminGroup
$admins = (Get-LocalGroupMember -Name Administrators).Name
$admins_parsed = @()
foreach ($admin in $admins){
    $split = $admin.split("\")
    $admins_parsed += $split[1]
}

$userexport =@()
foreach ($user in $users){
    # restting isadmin-var
    $isadmin = "false"

    # checking, whether user is admin
    if ($admins_parsed -contains $user.Name){
        $isadmin = "true"
    }

    # creating array-object for export
    $object = New-Object psobject
    $object | Add-Member NoteProperty Name $user.Name 
    $object | Add-Member NoteProperty PasswordRequired $user.PasswordRequired
    $object | Add-Member NoteProperty Enabled $user.Enabled
    $object | Add-Member NoteProperty LastLogon $user.LastLogon
    $object | Add-Member NoteProperty IsAdmin $isadmin
    $userexport += $object
}


$userexport | Export-Csv -Path "C:\userreport.csv" -Delimiter ";" -NoTypeInformation


