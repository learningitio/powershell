$diskinfo= Get-WmiObject -Class Win32_LogicalDisk

$result = @()
ForEach ($disk in $diskinfo) {  
    # Name
    $Volume = $disk.VolumeName  

    # Total Size in GB
    $TotalSizeGB = [math]::Round(($disk.Size /1GB),2)
    
    # Used Space in GB
    $UsedSpaceGB = [math]::Round((($disk.Size - $disk.FreeSpace)/1GB),2)
    
    # Free Space in GB
    $FreeSpaceGB = [math]::Round(($disk.FreeSpace / 1GB),2) 
    
    # Free Space in Percent
    if ($disk.FreeSpace -gt 0){
        $FreePer = ("{0:P}" -f ($disk.FreeSpace / $disk.Size)) 
    }

    # Free Space for Calc
    if ($disk.FreeSpace -gt 0){
        $FreePercalc = $disk.FreeSpace / $disk.Size
    }

    #Determine if disk needs to be flagged for warning or critical alert  
    If ($FreePercalc -lt  0.05) {  
        $status = "Critical"  
    } 
    ElseIf ($FreePercalc -ge 0.05 -AND $FreePercalc -lt 0.15) {  
        $status = "Low"                 
    } 
    Else {  
        $status = "Good"  
    }  


    $object = New-Object psobject
    $object | Add-Member NoteProperty Name $Volume
    $object | Add-Member NoteProperty GesamtgroesseInGB $TotalSizeGB
    $object | Add-Member NoteProperty GenutzterSpeicherInGB $UsedSpaceGB
    $object | Add-Member NoteProperty FreierSpeicherInGB $FreeSpaceGB
    $object | Add-Member NoteProperty FreierSpeicherProzent $FreePer
    $object | Add-Member NoteProperty FreierSpeicherPrStatusozent $status
    $result += $object

} 

