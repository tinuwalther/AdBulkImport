# Bulk import in Active Directory
BulkImport.ps1:
Bulk Import Groups to an Active Directory from a CSV-File.

## Start Script
.\BulkImport.ps1 -Inputfile .\import.csv  

## CSV File
GroupName|GroupType|GroupLocation|GroupDescription
---|---|---|---
DG_HR_Assistents|Global|"OU=Import,DC=contoso,DC=com"|Role HR-Assistents
DL_R_XXX|DomainLocal|"OU=Import,DC=contoso,DC=com"|Read-Permission to XXX
DL_W_XXX|DomainLocal|"OU=Import,DC=contoso,DC=com"|Write-Permission to XXX
