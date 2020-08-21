###
# The charts displaying data on consultants, asume that those are members of a group called "Consultants" change the name if needed.


#Servers to pull Performance counters from (besides Localhost) - https://docs.universaldashboard.io/components/monitors
$ServerOne = "DKESBPosh01"
$ServerTwo = "DKESBPoshUD01"

###
# set the overal appearance of the dashboard -  https://docs.universaldashboard.io/themes
$theme = Get-UDTheme Azure 

#region begin Scheduler
# https://docs.universaldashboard.io/endpoints/scheduled-endpoints
# An UDEndpoint is a scriptblock that runs at a interval defined by UDEndpointSchedule
# Data can be stored in $Cache:VariableName and is available throughout the dashboard.
$Schedule = New-UDEndpointSchedule -Every 1 -Minute

$AllUsersEndpoint = New-UDEndpoint -Schedule $Schedule -Endpoint {
    
    $ConsultantAccounts = Get-ADGroupMember Consultants | select SamaccountName
    
    # Feel free to set a searchbase to narrow down the returned data. Mo data = Mo time
    $AllAccounts = Get-ADUser -filter * -Properties LockedOut,Title,Department,AccountExpirationDate,Manager,Office
   
#region begin AllUsers
    # besides doing some calculated properties here, we also se a property called "Details", that will contain code to show a button and what clicking that button will do.
    $AllUsers = $AllAccounts |  Select-Object LockedOut,Office,SamAccountName,Name,Department,Title,accountexpirationdate,Manager,@{Name="ExpirationDate";Expression={
                            if($_.AccountExpirationDate -eq $null) 
                                { return "Never"}
                            else
                                {(Get-Date ($_.AccountExpirationDate)).tostring("yyyy-MM-dd HH-mm-ss")}
                            }},@{Name="State";Expression={
                                If($_.Enabled){
                                    If($_.AccountExpirationDate -lt (get-date) -and $_.AccountExpirationDate -ne $null){
                                        Return "Expired"
                                    }
                                    
                                    Return "Enabled"
                                }
                                Else
                                {
                                    Return "Disabled"
                                }
                            }},@{Name="Type";Expression={
                                If ($($ConsultantAccounts | Select-Object -ExpandProperty SamAccountName) -contains $_.SamAccountName) 
                                {
                                    Return "Consultant"
                                } 
                                Else 
                                {
       
                                    Return "Employee"
                                }
                            }},@{Name="Details";Expression={
                                New-UDButton -Text "Show Details" -OnClick (
                                    New-UDEndpoint -Endpoint {
                                        $EmployeeAD = Get-ADUser $($ArgumentList[0]) -Properties Title,Department,AccountExpirationDate,LockedOut
                                        
                                        $TableData =  @(
                                            [PSCustomObject]@{Name = "Username";  Value = $($EmployeeAD.SamAccountName); Sort = "1"}
                                            [PSCustomObject]@{Name = "Name";  Value = $($EmployeeAD.Name); Sort = "2"}
                                            [PSCustomObject]@{Name = "Title";  Value = $($EmployeeAD.Title); Sort = "3"}
                                            [PSCustomObject]@{Name = "Department";  Value = $($EmployeeAD.Department); Sort = "4"}
                                            [PSCustomObject]@{Name = "Enabled?";  Value = $(($EmployeeAD.Enabled).tostring()) ; Sort = "5"}
                                            [PSCustomObject]@{Name = "Locked?";  Value = $(if ($EmployeeAD.LockedOut -eq $false) {"Nope"} else {"Yep"}); Sort = "6"}
                                            [PSCustomObject]@{Name = "Account Expiration Date";  Value = $(if($EmployeeAD.AccountExpirationDate -eq $null) {"Never"} else {(Get-Date ($EmployeeAD.AccountExpirationDate)).tostring("yyyy-MM-dd HH-mm-ss")}); Sort = "7"}

                                        ).GetEnumerator()


                                        Show-UDModal -Header {
                                            New-UDHeading -Size 4 -Text "Here's what we have on $($EmployeeAD.Name)"
                                        } -Content { 
                                            New-UDCard -Title "Account Details" -Content {
                                                New-UDTable -Headers @("Attribute", "Value") -Endpoint {
                                                    $TableData | Sort-Object Sort | Out-UDTableData -Property @("Name", "Value")
                                                }
                                            }
                                        }
                                    } -ArgumentList $($_.ObjectGUID) 
                                )
    
                            }}

    $Cache:AllUsers = $AllUsers
    $Cache:AllConsultants = $AllUsers | Where -Property Type -eq "Consultant"

#endregion   

#region begin ByDepartment

    $Departments = $Cache:AllUsers | Select-Object -expandProperty Department -Unique | Sort 
    $ByDepartment = $null
    $ByDepartment = New-Object System.Collections.ArrayList
    
    Foreach ($Department in $Departments){
    
        $DepCount = @($Cache:AllUsers | Where -Property Department -eq $Department).count

        $Counter = [PSCustomObject]@{
            
        'Employees' = $($DepCount);
        'Department' = $Department;
        }
    
    
        $ByDepartment.add($Counter)
    }

    $Cache:ByDepartment = $ByDepartment

#endregion

#region begin ConsultantsByDepartment

    $ConsultantDepartments = $Cache:AllConsultants | Select-Object -expandProperty Department -Unique | Sort 
    $ConsultantByDepartment = $null
    $ConsultantByDepartment = New-Object System.Collections.ArrayList
    
    Foreach ($Department in $ConsultantDepartments){
    
        $ConsultantsDepCount = @($Cache:AllConsultants | Where -Property Department -eq $Department).count

        $Counter = [PSCustomObject]@{
            
        'Consultants' = $($ConsultantsDepCount);
        'Department' = $Department;
        }
    
    
        $ConsultantByDepartment.add($Counter)
    }

    $Cache:DepartmentConsultants = $ConsultantByDepartment
    $Cache:DepartmentNames = $Cache:AllConsultants | Select-Object -Property Department -Unique | Select -Property Department| Sort-Object

#endregion

#region begin ConsultantsByLocation

    $ConsultantOffices = $Cache:AllConsultants | Select-Object -ExpandProperty Office -Unique | Sort
    $ConsultantByOffice = $null
    $ConsultantByOffice = New-Object System.Collections.ArrayList
    
    Foreach ($Office in $ConsultantOffices){
    
    $ConsultantsOfficeCount = @($Cache:AllConsultants | Where -Property Office -eq $Office).count

        $Counter = [PSCustomObject]@{
            
        'Consultants' = $($ConsultantsOfficeCount);
        'Office' = $Office;
        }
    
    
        $ConsultantByOffice.add($Counter)
    }
    $Cache:OfficeConsultants = $ConsultantByOffice

#endregion

#region begin DeclineConsultants

    $cMonths = $null
    $cMonths = New-Object System.Collections.ArrayList
    for ($i = 0; $i -le 12; $i++) { 
        $Dayofthemonth = ((get-date -day 2).addmonths($i).Tostring("yyyy-MM-dd"))
        
        $cMonths.add($Dayofthemonth)  | Out-Null
    } 

    $ContractersPerMonth = $null
    $ContractersPerMonth = New-Object System.Collections.ArrayList

    Foreach ($cMonth in $cMonths){
        $Data = $Cache:AllConsultants | Where -Property AccountExpirationDate -ge $(Get-date $cMonth)

        $MonthData = [PSCustomObject]@{
            'Date' = $($cMonth);
            'Consultants' = @($Data).Count;
            }
        $ContractersPerMonth.add($MonthData) | out-null
    }


    $tMonths = $null
    $tMonths = New-Object System.Collections.ArrayList
    for ($i = 0; $i -le 12; $i++) { 
        $Dayofthemonth = ((get-date -day 1).addmonths($i).Tostring("yyyy-MM-dd"))
        
        $tMonths.add($Dayofthemonth)  | Out-Null
    } 

    $ContractorTerminationsPerMonth = $null
    $ContractorTerminationsPerMonth = New-Object System.Collections.ArrayList

    Foreach ($tMonth in $tMonths){
        $Data = $Cache:AllConsultants | Where {$_.AccountExpirationDate -ge (get-date $tMonth -Day 2) -and $_.AccountExpirationDate -le (get-date $tMonth).AddMonths(1)}
    
        $MonthData = [PSCustomObject]@{
            'Date' = $((Get-Date $tMonth).ToString("yyyy-MM"));
            'Consultants' = @($Data).Count;
            }
        $ContractorTerminationsPerMonth.add($MonthData) | out-null
    }

    $Cache:Contractersdecline = $ContractersPerMonth
    $Cache:ContractorTerminations = $ContractorTerminationsPerMonth

#endregion

}

###
### Pages
###

$EmployeePage = New-UDPage -Name "Employees Page" -Content {
    
    #Colours
    $ChartDataColour = "#2BBBAD" #-BackgroundColor
    $ChartHighlightColour = "#ffb347" #-HoverBackgroundColor
    $ChartBorderColour = "#252525" #-BorderColor -HoverBorderColor

    New-UDRow {
        
        New-UDColumn -LargeSize 12 {
            New-UDRow {
                New-UDColumn -LargeSize 4 -Content {


                    New-UDCounter -Title "Total Employees" -AutoRefresh -RefreshInterval 5 -TextAlignment Right -TextSize Large -Endpoint {
                            $(($Cache:AllUsers).count) | ConvertTo-Json
                    }
                   
                    New-UDCounter -Title "Locked Accounts" -AutoRefresh -RefreshInterval 5 -TextAlignment Right -TextSize Large -Endpoint {
                        $(($Cache:AllUsers | where-object LockedOut -eq $true).count) | ConvertTo-Json
                    }
                    New-UDCounter -Title "Expired Accounts" -AutoRefresh -RefreshInterval 5 -TextAlignment Right -TextSize Large -Endpoint {
                        $(($Cache:AllUsers | Where-Object State -eq "Expired").count) | ConvertTo-Json
                    }
                    New-UDCounter -Title "Disabled Accounts" -AutoRefresh -RefreshInterval 5 -TextAlignment Right -TextSize Large -Endpoint {
                        $(($Cache:AllUsers | Where-Object State -eq "Disabled").count) | ConvertTo-Json
                    }

                }
                New-UDColumn -LargeSize 8 -Content {
                    New-UDChart -Title "Distribution of Employees by Department" -Type Doughnut -AutoRefresh -RefreshInterval 5 -Endpoint {
                        $Cache:ByDepartment | Out-UDChartData -DataProperty "Employees" -LabelProperty "Department" -BackgroundColor $ChartDataColour -BorderColor $ChartBorderColour -HoverBackgroundColor $ChartHighlightColour -HoverBorderColor $ChartBorderColour
                    } -Options @{  
                        legend = @{  
                            display = $false  
                        }
                    }


                    New-UDCard -Content {
                        New-UDRow -Columns {
                            New-UDColumn -Size 10 -Content {
                        
                                    New-UDTextbox -Id "txtSearch" -Label "Search" -Placeholder "Search for an object - Wildcards * can be used (ex. Rene*)" -Icon search

                                }
                            New-UDColumn -Size 2 -Content {
                                New-UDButton -Id "btnSearch" -Text "Search" -OnClick {
                                    $Element = Get-UDElement -Id "txtSearch" 
                                    $Value = $Element.Attributes["value"]
            
                                    Set-UDElement -Id "results" -Content {
                                        New-UDGrid -Title "Search Results for: $Value" -Headers @("Username","Name", "More Info") -Properties @("Username","Name", "MoreInfo") -Endpoint {
                                            $Objects = $Cache:AllUsers | Where {($_.name -like "$Value") -or ($_.SamAccountName -like "$Value")}
                                            $Objects | ForEach-Object {
                                                [PSCustomObject]@{
                                                    Username = $_.SamAccountName
                                                    Name = $_.Name
                                                    MoreInfo = $_.Details
                                                }
                                            } | Out-UDGridData 
                                        } 
                                    }
                                }
                            }
                        }
                    }
                                        New-UDElement -Tag "div" -Attributes @{
                        style = @{
                            height = '25px'
                        }
                    }
                    New-UDRow -Columns {
                        New-UDColumn -SmallSize 10 -SmallOffset 1 {
                            New-UDElement -Tag "div" -Id "results"
                        }
                    }
                }
            }
        }
    }

}

$ConsultantPage = New-UDPage -Name "Consultants Page" -Content {
    
    #Colours
    $ChartDataColour = "#2BBBAD" #-BackgroundColor
    $ChartHighlightColour = "#ffb347" #-HoverBackgroundColor
    $ChartBorderColour = "#252525" #-BorderColor -HoverBorderColor

    New-UDRow {
        New-UDColumn -LargeSize 12 {
            New-UDRow {
                New-UDColumn -LargeSize 6 -Content {

                    New-UDColumn -LargeSize 6 -Content {

                        New-UDCounter -Title "Consultants" -AutoRefresh -RefreshInterval 5 -TextAlignment Right -TextSize Large -Endpoint {
			                    $(($Cache:AllConsultants).count) | ConvertTo-Json
		                    }

                        New-UDChart -Title "Distribution of Consultants by Department" -Type Doughnut -AutoRefresh -RefreshInterval 5 -Endpoint {
                            $Cache:DepartmentConsultants | Out-UDChartData -DataProperty "Consultants" -LabelProperty "Department" -BackgroundColor $ChartDataColour -BorderColor $ChartBorderColour -HoverBackgroundColor $ChartHighlightColour -HoverBorderColor $ChartBorderColour
                        } -Options @{  
                            legend = @{  
                                display = $false  
                            }
                        }
                        New-UDChart -Title "Distribution of Consultants by location" -Type Doughnut -AutoRefresh -RefreshInterval 5 -Endpoint {
                            $Cache:OfficeConsultants | Out-UDChartData -DataProperty "Consultants" -LabelProperty "Office" -BackgroundColor $ChartDataColour -BorderColor $ChartBorderColour -HoverBackgroundColor $ChartHighlightColour -HoverBorderColor $ChartBorderColour
                        } -Options @{  
                            legend = @{  
                                display = $false  
                            }
                        }
                    }
                    New-UDColumn -LargeSize 6 -Content {
                        New-UDChart -Title "Expirations by Month" -Type Bar -AutoRefresh -RefreshInterval 5 -Endpoint {
                            $Cache:ContractorTerminations | Out-UDChartData -DataProperty "Consultants" -LabelProperty "Date" -BackgroundColor $ChartDataColour -BorderColor $ChartBorderColour -HoverBackgroundColor $ChartHighlightColour -HoverBorderColor $ChartBorderColour
                        } -Options @{  
                            legend = @{  
                                display = $false  
                            };
                            scales = @{  
                                xAxes = @(
                                    @{
                                    ticks = @{
                                            display = $false
                                        }
                                    }
                                )
                            }
                        }
                        New-UDChart -Title "Decline by expiration date" -Type Line -AutoRefresh -RefreshInterval 5 -Endpoint {
                            $Cache:Contractersdecline | Out-UDChartData -DataProperty "Consultants" -LabelProperty "Date" -BackgroundColor $ChartDataColour -BorderColor $ChartBorderColour -HoverBackgroundColor $ChartHighlightColour -HoverBorderColor $ChartBorderColour
                        } -Options @{
                            legend = @{  
                                display = $false  
                            };
                            scales = @{  
                                xAxes = @(
                                    @{
                                        ticks = @{
                                            display = $false
                                        }
                                    }
                                )
                            }
                        }
                    }
                }
                New-UDColumn -LargeSize 6 -Content {
                    New-UDGrid -Title "Departments with Consultants" -Headers @("Department") -Properties @("Department") -DefaultSortColumn "Department" -NoPaging -Endpoint {
                    $Cache:DepartmentNames | Out-UDGridData
                    }
                }
            }
            New-UDColumn -LargeSize 12 {
                New-UDGrid -Title "All Consultants" -Headers @("Username", "Name", "Account State", "Expiration Date", "Title", "Department", "Office", "Details") -Properties @("SamAccountName", "Name", "State", "ExpirationDate", "Title", "Department", "Office", "Details") -DefaultSortColumn "ExpirationDate" -PageSize 50 -Endpoint {
                $Cache:AllConsultants | Out-UDGridData
                }
            }
        }
    }

}

$ServerPage = New-UDPage -Name "Servers Page" -Content {
    New-UDRow {
        New-UDColumn -LargeSize 4 -Content {
            New-UdMonitor -Title "Localhost - CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
                Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
            }
            New-UdMonitor -Title "$ServerOne - CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
                Get-Counter -ComputerName $ServerOne '\Processor(_Total)\% Processor Time' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
            }
            New-UdMonitor -Title "$ServerTwo - CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
                Get-Counter -ComputerName $ServerTwo '\Processor(_Total)\% Processor Time' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
            }

        }
        New-UDColumn -LargeSize 4 -Content {
            New-UdMonitor -Title "LocalHost - Memory (Available MB)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
                Get-Counter '\Memory\Available MBytes' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
            }
            New-UdMonitor -Title "$ServerOne - Memory (Available MB)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
                Get-Counter -ComputerName $ServerOne '\Memory\Available MBytes' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
            }
        
            New-UdMonitor -Title "$ServerTwo - Memory (Available MB)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
                Get-Counter -ComputerName $ServerTwo '\Memory\Available MBytes' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
            }
        
        }
        New-UDColumn -LargeSize 4 -Content { }
    }

}


$dashboard = New-UDDashboard -Title "Sample Dashboard" -Theme $theme -page @($EmployeePage, $ConsultantPage, $ServerPage)

Get-UDDashboard | Stop-UDDashboard
Start-UDDashboard -Port 10001 -Dashboard $dashboard -Endpoint @($AllUsersEndpoint) -Name "SampleDashboard"