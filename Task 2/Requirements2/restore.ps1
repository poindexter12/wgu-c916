# Seymour, Joseph 004521088
# WGU C916

<#
    .SYNOPSIS
    Script to automate the restoration of AD users and the contacts table in MSSQL

    .DESCRIPTION
    Running this will immediately execute restoration of AD users from the financePersonnel.csv 
    and insert users from the NewClientData.csv into MSSQL on the local machine
#>

# Load SMO assembly for MSSQL interactions
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')

Function CreateADUsers([String] $ouPath){
    <#
        .SYNOPSIS
        Create AD user
        
        .DESCRIPTION
        Reads users from financePersonnel.csv and create them in AD

        .PARAMETER ouPath
        Organizational Unit to place users into in AD
    #>
    Write-Host
    Write-Host "Create users from financePersonnel.csv"
    Write-Host "********************** START **********************"
    Write-Host

    try{
        Write-Host "OU Path is: $($ouPath)"
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
    }
    catch {
        Write-Host $Error[0].Exception
        Write-Host "Unhandled exception creating users"
        throw
    }

    Write-Host
    Write-Host "**********************  END  **********************"
    Write-Host
}

Function RestoreClients(){
    <#
        .SYNOPSIS
        Retores clients to database
        
        .DESCRIPTION
        Reads clients from NewClientData.csv and inserts them as records into Client_A_Contacts
    #>

    Write-Host
    Write-Host "Create ClientDB database"
    Write-Host "********************** START **********************"
    Write-Host

    # variables
    $serverName = "SRV19-PRIMARY\SQLEXPRESS"
    $databaseName = "ClientDB"
    # connection to server
    $srv = New-Object Microsoft.SqlServer.Management.Smo.Server($serverName)
    # make database object
    $db = New-Object Microsoft.SqlServer.Management.Smo.Database($srv, $databaseName)

    try{
        # drop the database if it exists
        $db.DropIfExists()
        # create the database
        $db.Create()
    }
    catch {
        Write-Debug $Error[0].Exception
        Write-Host "Unhandled exception creating database"
        throw
    }

    Write-Host "Database created"
    Write-Host
    Write-Host "**********************  END  **********************"
    Write-Host
    
    
    Write-Host
    Write-Host "Create Client_A_Contacts table"
    Write-Host "********************** START **********************"
    Write-Host

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
        Write-Debug $Error[0].Exception
        Write-Host "Unhandled exception creating table"
        throw
    }

    Write-Host "Table created"
    Write-Host
    Write-Host "**********************  END  **********************"
    Write-Host
    
    Write-Host
    Write-Host "Inserting records into table"
    Write-Host "********************** START **********************"
    Write-Host

    # create insert parameters
    $csvPath = "NewClientData.csv"
    $csvDelimiter = ","
    $tableSchema = "dbo"

    try{
        # insert data with import csv
        Import-Csv -Path $csvPath -Delimiter $csvDelimiter | Write-SqlTableData -ServerInstance $serverName -DatabaseName $databaseName -SchemaName $tableSchema -TableName $contactTableName
    }
    catch {
        Write-Debug $Error[0].Exception
        Write-Host "Unhandled exception inserting records"
        throw
    }

    Write-Host "Records inserted"
    Write-Host
    Write-Host "**********************  END  **********************"
    Write-Host
}

Function Main(){
    <#
        .SYNOPSIS
        Main function to execute restoring state
        
        .DESCRIPTION
        Restores users to AD and restores clients to the local MSSQL database
    #>
    # name of the OU
    $ouName = "finance"
    
    # Try to get the OU
    $organizationalUnit = Get-ADOrganizationalUnit -Filter "ou -eq '$ouName'"

    try{
        # Check to see if OU already exists
        if ($organizationalUnit) {
            Write-Host "OU $($ouName) already exists"
        }
        else {
            # Create an Active Directory organizational unit (OU) named finance"
            New-ADOrganizationalUnit $ouName
            $organizationalUnit = Get-ADOrganizationalUnit -Filter "ou -eq '$ouName'"
        }

        # Get path for each user in the OU
        $ouPath = $organizationalUnit.DistinguishedName

        # call to create the AD users
        CreateADUsers($ouPath)

        # call to restore clients
        RestoreClients
    }
    catch [System.OutOfMemoryException] {
        Write-Error $_
        Write-Host "An out of memory exception ocurred, exiting..."
        Exit 2
    }
    catch{
        Write-Debug $Error[0].Exception
        Write-Host "Unhandled exception executing main, exiting..."
        Exit 1
    }

}

# Call Main
Main