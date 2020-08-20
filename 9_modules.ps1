# https://www.powershellgallery.com/

Install-Module -Name PoshWSUS
Import-Module PoshWSUS
Get-Command -Module poshwsus
get-help Start-PSWSUSCleanup

#ModulPfade:
$env:PSModulePath


# Schreiben von Modulen:
# 1. Schreiben von Function
# 2. Abspeichern unter Pfad
# 3. Importieren