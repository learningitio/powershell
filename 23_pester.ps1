# Install
Install-Module Pester -Force -SkipPublisherCheck

# Grundgedanke -> Test-Driven Development...erst Tests, dann Funktionalität


Import-Module Pester

# neues Projekt
New-Fixture -Path .\ -Name "new"

# Describe
# It
# Should be|beexactly|throw



# Test
Describe "FirstTest" {
    It "true should be true" {
        $true | Should be $true
    }
}


function PesterFunction {
    write-host "test"
}