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
    
    # create contacts table
    $contactTable = New-Object Microsoft.SqlServer.Management.Smo.Table($db, "Client_A_Contacts")

    #Create reusable datatype objects
    $integerDataType = [Microsoft.SqlServer.Management.Smo.Datatype]::Int
    $nvarcharDataType = [Microsoft.SqlServer.Management.Smo.Datatype]::NVarChar(100)

    #Create the contact ID column
    $contactIdColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "ContactId", $integerDataType)
    $contactIdColumn.Identity = $true
    $contactIdColumn.IdentitySeed = 1
    $contactIdColumn.IdentityIncrement = 1
    $contactTable.Columns.Add($contactIdColumn)

    #Create the first_name column
    $firstNameColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "first_name", $nvarcharDataType)
    $contactTable.Columns.Add($firstNameColumn)

    #Create the last_name column
    $lastNameColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "last_name", $nvarcharDataType)
    $contactTable.Columns.Add($lastNameColumn)

    #Create the city column
    $cityColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "city", $nvarcharDataType)
    $contactTable.Columns.Add($cityColumn)

    #Create the county column
    $countyColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "county", $nvarcharDataType)
    $contactTable.Columns.Add($countyColumn)

    #Create the zip column
    $zipColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "zip", $nvarcharDataType)
    $contactTable.Columns.Add($zipColumn)

    #Create the officePhone column
    $officePhoneColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "officePhone", $nvarcharDataType)
    $contactTable.Columns.Add($officePhoneColumn)

    #Create the mobilePhone column
    $mobilePhoneColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "mobliePhone", $nvarcharDataType)
    $contactTable.Columns.Add($mobilePhoneColumn)
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