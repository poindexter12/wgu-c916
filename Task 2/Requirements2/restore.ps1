# Seymour, Joseph 004521088
# WGU C916

<#
    .SYNOPSIS
    Script to automate the onboarding of new employees

    .DESCRIPTION
    Running this script will give you the option of running various automated tasks for supporting
    the onboarding of new employees.
#>

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

    $srv = new-Object Microsoft.SqlServer.Management.Smo.Server("(local)")
    $db = New-Object Microsoft.SqlServer.Management.Smo.Database($srv, "ClientDB")
    $db.Create()
    Write-Host $db.CreateDate
}

# Call Main
Main