
<#
    .SYNOPSIS
     Test some things with pester

    .DESCRIPTION
     Test local Accounts or Groups

    .NOTES
     Author: Martin Walther
     Link:   https://it.martin-walther.ch
     https://github.com/pester/Pester/wiki/Invoke-Pester

    .EXAMPLE
     $PesterReturn += Invoke-Pester -Script @{
        Path = $script.FullName
    } -PassThru -OutputFormat NUnitXml -OutputFile $($Xmlfile)

#>
[CmdletBinding()]
param()

#region scriptglobals
$script:Scriptpath       = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests'
$script:Scriptname       = $MyInvocation.MyCommand.ToString()
#endregion

Import-Module "$($Internalfolder)\Assert-SystemCompliance.psm1" -Force

Describe -Name "Accounts Compliance Test" {  

    BeforeAll{
        if($Error){$Error.Clear()}
    }

    Context "Test Members of local Administrators" {
        # -- Arrange
        $ExceptionList = @("$($env:computername)\Tinu","$($env:computername)\Administrator")
        # -- Act
        $Actual = Get-MemberOfLocalAdmins -ExceptionList $ExceptionList
        # -- Assert
        It "Local Administrators should have only Administrator as Member" {
            $Actual | Should BeNullOrEmpty
        }
    }

}