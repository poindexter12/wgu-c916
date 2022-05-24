# Seymour, Joseph 004521088
# WGU C916

# Script to automate the onboarding of new employees

# Write host with blank lines above and below
Function WriteHostWithLines($message){
    Write-Host
    Write-Host $message
    Write-Host
}
# Function to append all the log files to the daily log
Function AppendLogFiles(){
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

# Function to write all the file names to contents
Function WriteFiles(){
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

# Function to list memory and cpu usage
Function ListMemoryAndCpuUsage(){
    Write-Host "Successfully listed memory and cpu usage"

    #$processor = Get-WmiObject win32_processor 
    $load = Get-CimInstance win32_processor | Measure-Object -Property LoadPercentage -Average

    WriteHostWithLines "CPU usage: $load"
}

# Function to list all processes by virtual size
Function ListProcessesByVirtualSize(){
    Write-Host "Successfully listed processes by virtual size"
    
    $Processes = Get-Process
    foreach ($ProcessItem in $Processes) {
        Write-Host $ProcessItem
    }
}

# Main function
Function Main () {
    Write-Host "Welcome to the WGU C916 Task 1 Script!"

    # Main do loop for repeating input request
    do {
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
            '4' { ListProcessesByVirtualSize }
            '5' { Break; }
            default {
                # Let the user know the input is not recognized
                Write-Host "Unknown option selected, please try again"
            }
        }

        Write-Host
    }
    # Keep doing this forever
    until($response -eq "5")
 }

# Call main
Main