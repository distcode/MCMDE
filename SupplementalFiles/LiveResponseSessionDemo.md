# Live response session

Demonstration commands in a live response session in MDE

1. Using Help
`help`
`help services`

1. find a file
`findfile name-of-file.ext`

1. get a file from device
`getfile c:\folder\name-of-file.ext`

1. put a file to the device
upload the file via portal to the library first
Get content of library
`library`
send file to device
`putfile AnyFile.txt -keep`
uploaded to C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads\

1. run a script from library
`run Script.ps1`
run a script from library with parameters
`run GetDriveInfo.ps1 -parameters "-Driveletter c"`
    ```PowerShell
    ## Demoscript
    param (
        [string]$Driveletter = 'c'
    )

    Get-Volume -DriveLetter $Driveletter
    ```

1. clean up library
`library delete Script.ps1`

1. Registry
`registry HKLM\System\CurrentControlSet\Control\CrashControl`
`registry HKLM\System\CurrentControlSet\Control\CrashControl\\Dumpfile`

1. Redirection
`persistence`
`persistence > myResult.txt`
myResult.txt is downloaded automatically
