# Seymour, Joseph 004521088
# WGU C916

<#
    .SYNOPSIS
    Script to automate the onboarding of new employees

    .DESCRIPTION
    Running this script will give you the option of running various automated tasks for supporting
    the onboarding of new employees.
#>

# Load SMO assembly for MSSQL interactions
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')

Function CreateADUsers([String] $ouPath){
    Write-Host
    Write-Host "Create users from financePersonnel.csv"
    Write-Host "********************** START **********************"
    Write-Host

    # Import Users
    Import-Csv "financePersonnel.csv" -Delimiter "," | %{
        $firstName = $_.First_Name
        $lastName = $_.Last_Name
        $samAccountName = $_.samAccount
        $displayName = $firstName + " " + $lastName
        $postalCode = $_.PostalCode
        $officePhone = $_.OfficePhone
        $mobilePhone = $_.MobilePhone

        New-ADUser -Path $ouPath -SamAccountName $samAccountName -GivenName $firstName -Surname $lastName -Name $displayName -DisplayName $displayName -PostalCode $postalCode -MobilePhone $mobilePhone -OfficePhone $officePhone
        
        Write-Host "Created account for $displayName"
    }

    Write-Host
    Write-Host "**********************  END  **********************"
    Write-Host
}

Function CreateDatabase(){
    # connection to server
    $srv = New-Object Microsoft.SqlServer.Management.Smo.Server("SRV19-PRIMARY\SQLEXPRESS")
    # make database object
    $db = New-Object Microsoft.SqlServer.Management.Smo.Database($srv, "ClientDB")
    # create the database
    $db.Create()
    # Write out the create date
    Write-Host $db.CreateDate
    
    
}

Function CreateSqlTable(){



}

Function InsertTableData(){

}

Function Main(){

    # name of the OU
    $ouName = "finance"
    
    # Try to get the OU
    $organizationalUnit = Get-ADOrganizationalUnit -Filter "ou -eq '$ouName'"

    # Check to see if OU already exists
    if ($organizationalUnit) {
        Write-Host "OU $finance already exists"
    }
    else {
        # Create an Active Directory organizational unit (OU) named finance"
        $organizationalUnit = New-ADOrganizationalUnit $ouName
    }

    # Get path for each user in the OU
    $ouPath = $organizationalUnit.DistinguishedName

    #CreateADUsers($ouPath)

    # Load SMO assembly
    #[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null

    CreateDatabase

    CreateSqlTable

    InsertTableData
}

# Call Main
Main