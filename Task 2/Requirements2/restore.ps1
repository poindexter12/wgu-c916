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

    # variables
    $serverName = "SRV19-PRIMARY\SQLEXPRESS"
    $databaseName = "ClientDB"
    # connection to server
    $srv = New-Object Microsoft.SqlServer.Management.Smo.Server($serverName)
    # make database object
    $db = New-Object Microsoft.SqlServer.Management.Smo.Database($srv, $databaseName)
    # create the database
    $db.Create()
    # Write out the create date
    Write-Host $db.CreateDate
    
    # create contacts table
    $contactTable = New-Object Microsoft.SqlServer.Management.Smo.Table($db, "Client_A_Contacts")

    # create reusable datatype objects
    $integerDataType = [Microsoft.SqlServer.Management.Smo.Datatype]::Int
    $nvarcharDataType = [Microsoft.SqlServer.Management.Smo.Datatype]::NVarChar(100)

    # create the contact ID column
    $contactIDColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "ContactID", $integerDataType)
    $contactIDColumn.Identity = $true
    $contactIDColumn.IdentitySeed = 1
    $contactIDColumn.IdentityIncrement = 1
    $contactTable.Columns.Add($contactIDColumn)

    # create the primary key with indexing
    $contactPrimaryKey = New-Object Microsoft.SqlServer.Management.Smo.Index ($contactTable, "PK_Contacts")
    $contactPrimaryKey.IndexKeyType = "DriPrimaryKey"
    $contactPrimaryKey.IsClustered = $true
    $contactIndexedColumn = New-Object Microsoft.SqlServer.Management.Smo.IndexedColumn ($contactPrimaryKey, "CompanyID")
    $contactPrimaryKey.IndexedColumns.Add($contactIndexedColumn)
    $contactTable.Indexes.Add($contactPrimaryKey)

    # create the first_name column
    $firstNameColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "first_name", $nvarcharDataType)
    $contactTable.Columns.Add($firstNameColumn)

    # create the last_name column
    $lastNameColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "last_name", $nvarcharDataType)
    $contactTable.Columns.Add($lastNameColumn)

    # create the city column
    $cityColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "city", $nvarcharDataType)
    $contactTable.Columns.Add($cityColumn)

    # create the county column
    $countyColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "county", $nvarcharDataType)
    $contactTable.Columns.Add($countyColumn)

    # create the zip column
    $zipColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "zip", $nvarcharDataType)
    $contactTable.Columns.Add($zipColumn)

    # create the officePhone column
    $officePhoneColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "officePhone", $nvarcharDataType)
    $contactTable.Columns.Add($officePhoneColumn)

    # create the mobilePhone column
    $mobilePhoneColumn = New-Object Microsoft.SqlServer.Management.Smo.Column ($contactTable, "mobliePhone", $nvarcharDataType)
    $contactTable.Columns.Add($mobilePhoneColumn)

    # create the table
    $contactTable.Create()

    # import sql module
    Install-Module SqlServer

    # create insert parameters
    $csvPath = "NewClientData.csv"
    $csvDelimiter = ","
    $tableSchema = "dbo"

    # insert data with import csv
    Import-Csv -Path $csvPath -Delimiter $csvDelimiter | Write-SqlTableData -ServerInstance $serverName -DatabaseName $databaseName -SchemaName $tableSchema -TableName $contactTable -Force
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

}

# Call Main
Main