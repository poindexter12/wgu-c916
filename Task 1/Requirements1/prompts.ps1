# Script to automate the onboarding of new employees

# Switch statement to prompt for input
# Accept inputs from 1 to 5

Function AppendLogFiles(){
    Write-Host "Successfully appended all *.log files to DailyLog.txt"
}

Function WriteFiles(){
    Write-Host "Successfully wrote all files to C916contents.txt"
}

Function ListMemoryAndCpuUsage(){
    Write-Host "Successfully listed memory and cpu usage"
}

Function ListProcessesByVirtualSize(){
    Write-Host "Successfully listed processes by virtual size"
}

Function Main () {
    Write-Host "Welcome to the WGU C916 Task 1 Script!"

    do {
        Write-Host "*********************************************"
        Write-Host "Press 1 to append *.log files to DailyLog.txt"
        Write-Host "Press 2 to write files to C916contents.txt"
        Write-Host "Press 3 to write files to C916contents.txt"
        Write-Host "Press 4 to write files to C916contents.txt"
        Write-Host "Press 5 to exit!"
        Write-Host "*********************************************"
        Write-Host
        Write-Host "Please provide your input here [1-5]: "

        $KeyInfo = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
        Write-Host "KeyPress received: $KeyInfo"

        Switch ($KeyInfo.Character) {
            '1' { AppendLogFiles }
            '2' { WriteFiles }
            '3' { ListMemoryAndCpuUsage }
            '4' { ListProcessesByVirtualSize }
            '5' { Exit 0 }
            else {
                Write-Host "Unknown option selected, please try again"
            }
        }    
    }
    until($KeyInfo.Character -Eq '5')
 }

Main