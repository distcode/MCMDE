# Lab: Attack Surface reduction

This labguide shows you how to create an Endpoint Security policy to reduce the attack surface reduction on devices.

## Task 1: Service-to-Service connection Intune

1. Open a browser and navigate to the Intune portal (<https://intune.microsoft.com>).
2. Sign in as an administrator.
3. Select *Endpoint Security* in navigataion menu.
4. In the blade's menu select *Microsoft Defender for Enpoint* under Setup.
5. Set 'Allow Microsoft Defender for Endpoint to enforce Endpoint Security Configurations' to **On**.
6. Set 'Connect Windows devices version 10.0.15063 and above to Microsoft Defender for Endpoint' to **On**.
7. Click *Save* in the command button bar.
8. Navigate to the Defender portal (<https://defender.microsoft.com>) and sign in as an administrator.
9. Click *Settings* in the navigation menu and then *Endpoints*.
10. Search for the advanced feature 'Microsoft Intune connection' and set it to **On**.
11. At the buttom of the page click **Save preferences**.
    >Note: Now you have configured the service-to-service connection for Microsoft Defender for Endpoint and Intune. The next steps will set MDE as the service which enforces the security settings for devices. Afterwards, it's possible to apply security settings to devices which are not enrolled in Intune.
12. In the Endpoints settings blade click *Enforcement scopes* under Configuration management.
13. Set 'Use MDE to enforce security configuration settings from Intune' to **On**.
14. Under 'Enable configuration management' select 'Windows Client' and *On tagged devices*.
15. Select 'Windows Server devices' and *On all devices*.
16. Select 'macOS devices' and *On tagged devices*.
17. Set 'Security settings management for Microsoft Defender for Cloud onboarded devices' to *On*.
18. Scroll down and at the bottom right click the button **Save**.

## Task 2: MDE Security enforcement

Performe the following steps to set MDE for devices.

1. Navigate to the defender portal (<https://defender.microsoft.com>), sign in as adminsitrator and click *Devices* in the section 'Assets'.
2. Click the devicename of your onboarded Windows client. The device page opens.
3. In the device action menu select *Manage tags'.
4. Add the tag ***MDE-Management***.
5. Click **Save and close**.
6. To check the success wait some minutes (or restart the client), refresh the device page and search for 'Device management in the 'Overview' section.
7. Under 'MDE Enrollment status' you should see *Success*.
8. For the onboarded server you do not need to add a tag due to the enforcment settings. Just wait and check the 'MDE Enrollment status' on the device page.

## Task 3: Endpoint Security policy for ASR Rules

Create an Enpoint Security policy to set some attack surface reduction rules.

1. Navigate to the defender portal (<https://defender.microsoft.com>), sign in as adminsitrator and click *Configuration Managment* in the section 'Endpoints'.
2. Click 'Endpoint security policies'.
3. Click **+ Create new Policy**.
4. Select the platform Windows.
5. Select the template 'Attack Surface Reduction Rules'
6. Name the rule 'ASR rules Standard' and click **Next**.
7. Configure the rules as followed:

    | Rule | Setting |
    | --- | --- |
    | Block Win32 API calls from Office macros | Block |
    | Block JavaScript or VBScript from launching downloaded executable content | Block |
    | Use advanced protection against ransomware | Block |
    | Block Office applications from injecting code into other processes | Audit |
    | Block Office applications from creating executable content | Warn |

8. Set 'Enable Controlled Folder Access' to 'Enabled'.
9. As 'Controlled Folder Access Protected Folder' add *'c:\CompanyData'*.
10. And the 'Controlled Folder Access Allowed Applications' section add *'notepad.exe'*.
11. Click **Next**.
12. Search for the Entra ID Group 'SecDevWinClients' and select it for assignment.
13. Scroll down and click **Next**.
14. Review your settings and at the bottom right click **Save**.
15. Take a look at the policy page.
16. In the bread crumb navigation click *Endpoint Security Policies*.
    >Note: Now you have created a new policy. The next steps will sync the new policy to your device.
17. Select *Devices* under 'Assets' and click the name of the Windows client.
18. In the device page open the device action menu and click **Policy sync**.
    >Note: Instead of waiting 10 minutes proceed with the next tasks before checking the sync result.

## Task4 : Endpoint Security policy Defender for Antivirus

The next policy you will create ensures that next-generation protection is enabled on your devices.

1. In the navigation menu select 'Configuration Management' under 'Endpoints' and then *Endpoint security polices* again.
2. Click **+ Create new Policy**.
3. Select the platform Windows.
4. Select the template 'Windows Defender Antivirus'
5. Name the rule 'Next-generation protection Standard' and click **Next**.
6. Configure the rules as followed:

    | Rule | Setting |
    | --- | --- |
    | Enable Network Protection | Enabled (block-mode) |
    | PUA Protection | PUA Protection on. |
    | Submit Samples Consent | Send all samples automatically. |
    | Allow Cloud Protection | Allowed |
    | Allow Behavior Monitoring | Allowed |
    | Allow scanning of all downloaded files and attachments | Allowed |
    | Allow Realtime Monitoring | Allowed |
    | Allow On Access Protection | Allowed |

7. Scroll down and click **Next**.
8. Search for the Entra ID Group 'SecDevWinClients' and select it for assignment.
9. Click **Next**.
10. Review your settings and at the bottom right click **Save**.
11. Take a look at the policy page.
12. In the bread crumb navigation click *Endpoint Security Policies*.
13. Select *Devices* under 'Assets' and click the name of the Windows client.
14. In the device page open the device action menu and click **Policy sync**.
    >Note: Instead of waiting 10 minutes proceed with the next tasks before checking the sync result.

## Task 5: Endpoint Security policy Defender for Antivirus Exclusions

With the next policy you configure some exclusions for Microsoft Defender for Antivirus.

1. In the navigation menu select 'Configuration Management' under 'Endpoints' and then *Endpoint security polices* again.
2. Click **+ Create new Policy**.
3. Select the platform Windows.
4. Select the template 'Windows Defender Antivirus exclusions'
5. Name the rule 'AV Exclusion for LoB' and click **Next**.
6. Add the extension 'dst'.
7. Add the excluded path *'c:\WorkingData'*.
8. Click **Next**.
9. Search for the Entra ID Group 'SecDevWinClients' and select it for assignment.
10. Click **Next**.
11. Review your settings and at the bottom right click **Save**.
12. Take a look at the policy page.
13. In the bread crumb navigation click *Endpoint Security Policies*.
    >Note: In the list of Endpoint Security Policies your should see now three different entries under Windows policies.
14. Select *Devices* under 'Assets' and click the name of the Windows client.
15. In the device page open the device action menu and click **Policy sync**.

## Task 6: Check the policy enforcment on device

Perform the next steps on your Windows client VM as administrator.

<!--
    check asr rules - guids and setting
    # cfa
        create a file in c:\companydata - demo.txt
        try to open with npp first then notepad
    # get-mppreference and get-mpcomputerstatus

    # test ngp
        smartlinkdownload
        eicar file on desktop

    # exclusion
    create a file (demo.dst = eicar !!! ) in c:\workingdata
-->
### Task 6.1 Check Attack Surface Reduction Rules

1. Open a PowerShell console as administrator.
2. Type the following cmdlet to get configured ASR rules:
`Get-MpPreference | Format-List AttackSurfacereductionrules_Ids`
3. Refer to this link <https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-reference#asr-rule-to-guid-matrix> to check the configured rules.
4. To get the configured mode for each rule type
`Get-MpPreference | Format-List AttackSurfacereductionrules_Actions`
The order of the modes is the same as the order for the actions.
5. The next shows it more comfortable:

    ```PowerShell
    (Get-MpPreference).AttackSurfaceReductionRules_Ids | 
    Foreach-Object -Begin { $i = 0; $Actions = (Get-MpPreference).AttackSurfaceReductionRules_Actions } -Process { "$_ .. $($Actions[$i])"; $i++ }
    ```

6. The mode could be check here: <https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-reference#asr-rule-modes>.

### Task 6.2 Check Controlled Folder Access

1. Switch to your already opened PowerShell console.
2. Type the following cmdlet to get Controlled Folder Access configurations:
`Get-MpPreference | Format-List *Controll*`
3. To see it working, try to create a file in the controlled folder:
`Set-Content -Value 'Any Text in a text file.' -Path C:\CompanyData\demofile.txt`
    >Note: You should get an error message in your console and a toast notification. Consoles are treated as untrusted.
4. Type the following to get the appropriate event log entry:

    ```PowerShell
    Get-WinEvent -LogName 'Microsoft-Windows-Windows Defender/Operational' |
    Where-Object { $_.id -eq 1123 } |
    Select-Object -First 1 |
    Format-List
    ```

### Task 6.3 Check Next-generation protection settings

1. To get network protection state:
`Get-MpPreference | Format-List EnableNetworkProtection`
The value 1 indicates it is enabled.
2. To get behavior monitoring state:
`Get-MpPreference | Format-List DisableBehaviorMonitoring`
The value *False* indicates the state is on.
3. The state of cloud protection could be checked by:
`Get-MpPreference | Format-List MAPSReporting`
The value 2 stands for turned on.
4. The Sample submission consent could be seen by:
`Get-MpPreference | Format-List SubmitSamplesConsent`
5. Realtime monitoring check by:
`Get-Mppreference | Format-List DisableRealtimeMonitoring`
6. Check PUA protection by:
`Get-MpPreference | Format-List PUAProtection`
7. 'On Access Protection' is checked by:
`Get-MpComputerStatus | Format-List OnAccessProtectionEnabled`
8. The state of the setting 'Allow scanning of all downloaded files and attachments' could be seen by:
`Get-MpPreference | Format-List DisableScanningNetworkFiles`
9. Try now the following:
`Invoke-WebRequest -Uri 'https://smartscreentestratings2.net/'`
    >Note: You will get an error message in your console and  a notification titled: 'This content is blocked as malicious'. This is because you turned on Network Portection.

### Task 6.4 Check Antivirus exclusions

1. Use the following cmdlet to see configured Antivirus exclusions:
`Get-MpPreference | Format-List Exclusion*`
2. Now, let's see if it works. Create a demo virus file on your desktop:
`Set-Content -Path C:\Users\LocalAdmin\Desktop\demofile-bad.txt -Value 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'`
    >Note: You will get a toast notification with the tile 'Threats found' and after a short while the file on the desktop will be deleted/quarantined. This is intended to show you that AV is working.
3. Create a file in the exclusion folder with the same content but the extension *dst*:
`Set-Content -Path C:\WorkingData\demofile-bad.dst -Value 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'`
    >Note: This time the file will not be examined and will not be deleted/quarantined.
