# Script to automate the onboarding of new employees

# Switch statement to prompt for input
# Accept inputs from 1 to 5

Function AppendLogFiles(){
    Write-Debug -NoNewline "Successfully appended all *.log files to DailyLog.txt"
}

Function WriteFiles(){
    Write-Debug -NoNewline "Successfully wrote all files to C916contents.txt"
}

Function ListMemoryAndCpuUsage(){
    Write-Debug -NoNewline "Successfully listed memory and cpu usage"
}

Function ListProcessesByVirtualSize(){
    Write-Debug -NoNewline "Successfully listed processes by virtual size"
}

Function Run ($Message = "Press any key to continue...") {
    # Check if running in PowerShell ISE
    If ($psISE) {
       # "ReadKey" not supported in PowerShell ISE.
       # Show MessageBox UI
       $Shell = New-Object -ComObject "WScript.Shell"
       $Button = $Shell.Popup("Click OK to continue.", 0, "Hello", 0)
       Return
    }
  
    $Ignore =
       16,  # Shift (left or right)
       17,  # Ctrl (left or right)
       18,  # Alt (left or right)
       20,  # Caps lock
       91,  # Windows key (left)
       92,  # Windows key (right)
       93,  # Menu key
       144, # Num lock
       145, # Scroll lock
       166, # Back
       167, # Forward
       168, # Refresh
       169, # Stop
       170, # Search
       171, # Favorites
       172, # Start/Home
       173, # Mute
       174, # Volume Down
       175, # Volume Up
       176, # Next Track
       177, # Previous Track
       178, # Stop Media
       179, # Play
       180, # Mail
       181, # Select Media
       182, # Application 1
       183  # Application 2
  
    Write-Host "Welcome to the WGU C916 Task 1 Script!"
    Write-Host "Press 1 to append *.log files to DailyLog.txt"
    Write-Host "Press 2 to write files to C916contents.txt"
    Write-Host "Press 3 to write files to C916contents.txt"
    Write-Host "Press 4 to write files to C916contents.txt"
    Write-Host "Press 5 to exit!"
    Write-Host "Please provide your input here [1-5]: "

    While ($KeyInfo.VirtualKeyCode -Eq $Null -Or $Ignore -Contains $KeyInfo.VirtualKeyCode) {
       $KeyInfo = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")

       Switch ($KeyInfo) {
       1 { AppendLogFiles }
       2 { WriteFiles }
       3 { ListMemoryAndCpuUsage }
       4 { ListProcessesByVirtualSize }
       5 { exit }
       else {
           Write-Host "Unknown option selected, please try again"
           Write-Host
           Write-Host "Please provide your input here [1-5]: "
       }
    }
    }
 }

Run