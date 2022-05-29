# Seymour, Joseph 004521088
# WGU C916

<#
    .SYNOPSIS
    Script to automate the onboarding of new employees

    .DESCRIPTION
    Running this script will give you the option of running various automated tasks for supporting
    the onboarding of new employees.
#>

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
        # Create an Active Directory organizational unit (OU) named “finance"
        $organizationalUnit = New-ADOrganizationalUnit $ouName
    }

    # Get path for each user in the OU
    $ouPath = $organizationalUnit.DistinguishedName

    # Import Users
    Import-Csv "financePersonnel.csv" -Delimiter "," | %{
        $firstName = $_.First_Name
        $lastName = $_.Last_Name
        $samAccountName = $_.samAccount
        $displayName = $firstName + " " + $lastName
        $postalCode = $_.PostalCode
        $officePhone = $_.OfficePhone
        $mobilePhone = $_.MobilePhone

        Write-Host $displayName

        New-ADUser -Path $ouName -SamAccountName $samAccountName
    }

    Exit 0

    foreach ($financePerson in $financePersonnel) {
        Write-Host "Making user for $financePerson.samAccount"
        try {
            New-ADUser -Path $ouPath -SamAccountName $financePerson.samAccount -GivenName $financePerson.First_Name -Surname $financePerson.Last_Name -Name "$financePerson.First_Name $financePerson.Last_Name" -DisplayName "$financePerson.First_Name $financePerson.Last_Name" -PostalCode $financePerson.PostalCode -OfficePhone $financePerson.OfficePhone -MobilePhone $financePerson.MobilePhone -Enable $True -City $financePerson.City

            
            Write-Host "The user account $financePerson.samAccount is created"
        }
        catch {
            Write-Host "There was an error for user account $financePerson.samAccount" -ForegroundColor Red
            Write-Host $_.Exception.Message
        }
    }

}

# Call Main
Main