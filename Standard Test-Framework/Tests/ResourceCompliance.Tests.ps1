
<#
    .SYNOPSIS
     Test some things with pester

    .DESCRIPTION
     Test Memory and Disks

    .NOTES
     Author: Martin Walther
     Link:   https://it.martin-walther.ch
     https://github.com/pester/Pester/wiki/Invoke-Pester

    .EXAMPLE
     $PesterReturn += Invoke-Pester -Script @{
        Path = $script.FullName
    } -PassThru -OutputFormat NUnitXml -OutputFile $($Xmlfile)

#>

#region scriptglobals
$script:Scriptpath       = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests'
$script:Scriptname       = $MyInvocation.MyCommand.ToString()
#endregion

Import-Module "$($Internalfolder)\Assert-SystemCompliance.psm1" -Force

Describe -Name "Resource Compliance Test" {  

    BeforeAll{
        if($Error){$Error.Clear()}
    }

    Context "Test Memory" {
        # -- Arrange
        $ThresholdMemoryPercent = 30
        # -- Act
        $Actual = Get-Raminfo -threshold $ThresholdMemoryPercent
        # -- Assert
        It "Free Memory in percent should be greather than $($ThresholdMemoryPercent)%" {
            [Int]$Actual.'Free(%)' | Should BeGreaterThan $ThresholdMemoryPercent
        }
    }

    Context "Test Disks" {
        # -- Arrange
        $ThresholdFreeSpacePercent = 30
        # -- Act
        $Actual = Get-Diskinfo -threshold $ThresholdFreeSpacePercent
        # -- Assert
        It "Free Disk space in percent should be greather than $($ThresholdFreeSpacePercent)%" {
            [Int]$Actual.'Free(%)' | Should BeGreaterThan $ThresholdFreeSpacePercent
        }
    }
    
}
