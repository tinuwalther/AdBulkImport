<#
.SYNOPSIS
    Active Directory Bulk Import

.DESCRIPTION
    Massenimport von Active Directory Gruppen

.PARAMETER Inputfile
    Pfad zum Inputfile

.NOTES
    Author: Martin Walther
    Date created: 13.01.2015

.EXAMPLE
    .\BulkImport.ps1 -Inputfile .\import.csv

#>
#============================================================================================================================
param (
    [Parameter(Mandatory=$true)][String] $Inputfile
)
#============================================================================================================================
$ErrorActionPreference = 'SilentlyContinue'
Import-Module ActiveDirectory
$OuExists = $false
#============================================================================================================================
$csv = Import-Csv  $Inputfile
ForEach ($item In $csv) {
    $TargetOu = $($item.GroupLocation)
    try{
        Get-ADOrganizationalUnit -Identity $($item.GroupLocation) | Out-Null
        $OuExists = $true
    }
    catch{
        $OuExists = $false
        $error.clear()
    }
    if ($OuExists -eq $true){
        try{
            $exists = Get-ADGroup $($item.GroupName)
            "$(get-date -f 'yyyy-MM-dd HH:mm:ss') INFO: Group $($item.GroupName) alread exists! Group creation skipped!" | Out-File .\import.log ascii -Append
        }
        catch{
            $error.clear()
            try{
                New-ADGroup -Name $($item.GroupName) -GroupScope $($item.GroupType) -Description $($item.GroupDescription) -Path $($item.GroupLocation) -PassThru
                Set-ADGroup $($item.GroupName) -Replace @{info=”Created: $(get-date -f 'yyyy-MM-dd HH:mm:ss')”}
                "$(get-date -f 'yyyy-MM-dd HH:mm:ss') INFO: Group $($item.GroupName) successfully created!" | Out-File .\import.log ascii -Append
            }
            catch{
                "$(get-date -f 'yyyy-MM-dd HH:mm:ss') ERROR: Group $($item.GroupName) not created! Error: $($item.Exception.Message)" | Out-File .\import.log ascii -Append
            }
        }
    }
}
#============================================================================================================================
if($OuExists -eq $false){
    "$(get-date -f 'yyyy-MM-dd HH:mm:ss') ERROR: Target OU $($TargetOu ) can't be found! Group creation skipped!" | Out-File .\import.log ascii -Append
}
start notepad .\import.log
#=========================================================== EOF ============================================================
