# Onboarding MacOS

## Introduction

This article describes two methods to onboard MacOS devices. Onboarding is the process of connecting an endpoint to MDE.

To start onboarding navigate in the MS Defender portal to Settings / Endpoint. In the section _Device managment_ click _Onboarding_.

Select the operation system and follow the instructions under Item 1. In most cases, firstly choose the _Connectivity type_. __Streamlined__ is less complex in configuring your firewall than __Standard__. For more information see [here](https://learn.microsoft.com/en-us/defender-endpoint/configure-device-connectivity).

## Deployment Methods

After that, you have to choose your preferred _Deployment Method_.

- Local script [:arrow_down:](#local-script)
- Microsoft Endpoint Configuration Manager [:arrow_down:](#microsoft-endpoint-configuration-manger)

### Local Script

This method is suitable to be used for test devices, because you have to configure multiple settings on devices.

Firstly, click the button _Download __Installation__ package_. The installation packege is the app __Microsoft Defender__ on Mac OS. It is compareable with the Windows Defender Service in Windows 10/11. It is that app, which runs in the background and performs all the supported security tasks offered by Microsoft Defender for Endpoint.

To install this app, search for the file in your download directory and open it. Follow these [instructions](https://learn.microsoft.com/en-us/defender-endpoint/mac-install-manually#application-installation-macos-11-and-newer-versions) for a successfull installation.

Also perform the steps to allow

- [Full Disk Access](https://learn.microsoft.com/en-us/defender-endpoint/mac-install-manually#allow-full-disk-access) 
- [Background Execution](https://learn.microsoft.com/en-us/defender-endpoint/mac-install-manually#background-execution)
- and [Bluetooth access](https://learn.microsoft.com/en-us/defender-endpoint/mac-install-manually#bluetooth-permissions)
  
Secondly, back in the MDE portal, click the button _Download __onboarding__ package_. This is a script which creates a configuration file for Microsoft Defender under ```/Library/Application Support/Microsoft/Defender/com.microsoft.wdav.atp.plist```. The content of that file allows the Microsoft Defender to be connected to your tenant' MDE.

To onboard your device, follow these [instructions](https://learn.microsoft.com/en-us/defender-endpoint/mac-install-manually#onboarding-package).

### Onboard via Intune

Using this method, you have to download the _Installation package_ and the _onboarding package_ as well.

But the app and the settings is deliverd to your devices via Intune as App and configuration profile.

Microsoft has a [guide](https://learn.microsoft.com/en-us/defender-endpoint/mac-install-with-intune) with 18 steps for configuring Microsoft Intune to onboard a Mac OS devices. Not all steps are mandatory. Based on that guide, the nescessary steps are described here:



<!-- [ ] Add description for all steps >
<!-- [x] Just a test for completing ... >
