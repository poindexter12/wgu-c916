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

    # Create an Active Directory organizational unit (OU) named “finance"
    New-ADOrganizationalUnit "finance"

    # Import Users
    $financePersonnel = Import-Csv "financePersonnel.csv" -Delimiter ","
    foreach ($financePerson in $financePersonnel) {
        try {
            New-ADUser
                -SamAccountName $financePerson.samAccount
                -GivenName $financePerson.First_Name
                -Surname $financePerson.Last_Name
                -Name "$financePerson.First_Name $financePerson.Last_Name"
                -DisplayName "$financePerson.First_Name $financePerson.Last_Name"
                -PostalCode $financePerson.PostalCode
                -OfficePhone $financePerson.OfficePhone
                -MobilePhone $financePerson.MobilePhone
                -Enable $True
                -City $financePerson.City
                -Path "finance"

            
            Write-Host "The user account $financePerson.samAccount is created"
        }
        catch {
            Write-Host "There was an error for user account $financePerson.samAccount" -ForegroundColor Red
        }
    }

}

# Call Main
Main