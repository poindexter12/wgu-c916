  # Seymour, Joseph 004521088
# WGU C916

<#
    .SYNOPSIS
    Script to automate the onboarding of new employees

    .DESCRIPTION
    Running this script will give you the option of running various automated tasks for supporting
    the onboarding of new employees.
#>

Function WriteHostWithLines($message){
    <#
        .SYNOPSIS
        Add blank lines above and below message
        
        .DESCRIPTION
        WriteHostWithLines writes a message with blank lines above and below

        .PARAMETER message
        Message to surround with blank lines
    #>

    Write-Host
    Write-Host $message
    Write-Host
}

Function AppendLogFiles(){
    <#
        .SYNOPSIS
        Append all the log files to DailyLog.txt
    #>

    # Where to write the output to
    $DailyLogFileName = "DailyLog.txt"
    # Current date
    $CurrentDateTime = Get-Date
    # Get all of the files that have the log extension
    $LogFiles = Get-ChildItem *.log

    # Append start of log
    Add-Content $DailyLogFileName "Log for $CurrentDateTime"
    # Append start of log
    Add-Content $DailyLogFileName "***************** START *****************"
    # Loop through all the files
    foreach ($LogFileItem in $LogFiles) {
        # Add the file name to the file
        Add-Content $DailyLogFileName -Value $LogFileItem.Name
    }
    # Append end of log
    Add-Content $DailyLogFileName "*****************  END  *****************"
    # Append newline for ease of reading
    Add-Content $DailyLogFileName "`r`n"

    WriteHostWithLines "Successfully appended all *.log files to DailyLog.txt"
}

Function WriteFiles(){
    <#
        .SYNOPSIS
        Write all the file names to C916contents.txt
    #>
    
    # Where to write the output to
    $ContentFile = "C916contents.txt"
    if (Test-Path $ContentFile) {
        Remove-Item $ContentFile
    }

    # Get all of the files from here
    $LogFiles = Get-ChildItem | Sort-Object

    # Loop through the files
    foreach ($LogFileItem in $LogFiles) {
        # Add the file name to the file
        Add-Content $ContentFile -Value $LogFileItem.Name
    }

    WriteHostWithLines "Successfully wrote all files to C916contents.txt"
}

Function ListMemoryAndCpuUsage(){
    <#
        .SYNOPSIS
        List memory and cpu usage.
    #>
    
    # Get the cpu usage average
    $CpuUsage = (Get-WmiObject Win32_Processor | Measure-Object -property LoadPercentage -Average | Select Average ).Average

    Write-Host "CPU usage: $CpuUsage%"

    # OS object containing memory info
    $OperatingSystem = Get-WmiObject Win32_OperatingSystem

    # Calculate the used memory, divide to get GB, then round 2 digits
    $MemoryUsage = [Math]::Round(($OperatingSystem.TotalVisibleMemorySize - $OperatingSystem.FreePhysicalMemory)/1024/1024, 2)
    # Calculate the percentage of memory used, multiply by 100 to get percentage, then round whole number
    $MemoryPercentage = [Math]::Round($OperatingSystem.FreePhysicalMemory / $OperatingSystem.TotalVisibleMemorySize * 100)

    Write-Host "Memory usage: $MemoryUsage GB ($MemoryPercentage%)"
}

Function ListProcessesByVirtualMemorySize(){
    <#
        .SYNOPSIS
        List all processes by virtual memory size.
    #>
    
    Get-Process | Sort-Object -Property VM | Out-GridView

    WriteHostWithLines "Opened in GridView"
}

Function Main () {
    <#
        .SYNOPSIS
        Main function to execute loop for inputs.
    #>

    Write-Host "Welcome to the WGU C916 Task 1 Script!"

    # Main do loop for repeating input request
    do {
        try {
            
            Write-Host "*********************************************************"
            Write-Host "1 to append *.log files to DailyLog.txt"
            Write-Host "2 to write files to C916contents.txt"
            Write-Host "3 to write files to list memory and cpu usage"
            Write-Host "4 to write files to list processes by virtual size"
            Write-Host "5 to exit!"
            Write-Host "*********************************************************"
            Write-Host

            # Read the key pressed by user
            $response = Read-Host "Please provide your input and press ENTER"
            Write-Debug "KeyPress received: $KeyInfo"
            Write-Host

            # Switch based on the keyinfo character
            Switch ($response) {
                '1' { AppendLogFiles }
                '2' { WriteFiles }
                '3' { ListMemoryAndCpuUsage }
                '4' { ListProcessesByVirtualMemorySize }
                '5' { Break; }
                default {
                    # Let the user know the input is not recognized
                    Write-Host "Unknown option selected, please try again"
                }
            }

            Write-Host
        }
        catch [System.OutOfMemoryException] {
            Write-Error $_
            Write-Host "An out of memory exception ocurred, exiting..."
            Exit 2
        }
        catch {
            Write-Error $_
            Write-Host "Unhandled exception occurred, exiting..."
            Exit 1
        }
    }
    # Keep doing this forever
    until($response -eq "5")

    Exit 0
 }

# Call main
Main 