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
    # drop the database if it exists
    $db.DropIfExists()
    # create the database
    $db.Create()
    # Write out the create date
    Write-Host "Database created"
    
    # table name
    $contactTableName = "Client_A_Contacts"
    # create contacts table
    $contactTable = New-Object Microsoft.SqlServer.Management.Smo.Table($db, $contactTableName)

    # create reusable datatype objects
    $nvarcharDataType = [Microsoft.SqlServer.Management.Smo.Datatype]::NVarChar(100)
    
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
 
    try{
        # create the table
        $contactTable.Create()
    }
    catch {
        Write-Host $Error[0].Exception
        Write-Host "Unhandled exception occurred, exiting..."
        Exit 1
    }

    # create insert parameters
    $csvPath = "NewClientData.csv"
    $csvDelimiter = ","
    $tableSchema = "dbo"

    # insert data with import csv
    Import-Csv -Path $csvPath -Delimiter $csvDelimiter | Write-SqlTableData -ServerInstance $serverName -DatabaseName $databaseName -SchemaName $tableSchema -TableName $contactTableName
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

    CreateADUsers($ouPath)

    CreateDatabase

}

# Call Main
Main