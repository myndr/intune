# Installing Myndr in Microsoft Intune


>When your school doesn't use Basispoort, [please refer to the separate guide](./Readme-standalone.md).




## Installing
Installing Myndr is done by adding a configuration policy in Intune and assigning it to the student groups.  
We've created a configuration policy file for your convenience. This configuration policy also takes care of the requirements needed to make Myndr run smoothly and to make sure students are forced to comply to the usage.  
You can [read more about the configuration policy file in this separate document](./src/Basispoort/policy.basispoort-wr.md).


Take the following steps to fix requirements and install Myndr for Edge and Chrome in the right device groups:

1. Download the latest [Intune configuration policy file](./src/Basispoort/Myndr_Basispoort-with-requirements.policy.json) from the repository. 
2. Log in at [Microsoft Intune ](https://intune.microsoft.com/)
3. Click _Devices_ > _Windows_ > _Configuration_
4. Click _Create_ and click _Import policy_
5. Drag and drop the downloaded JSON file at the designated field
6. Type "Myndr" in the _New name*_ field (Or "Myndr-Beta" if you're installing the Beta version)
7. Type "Install Myndr and configure requirements" in the _New description_ field
8. Click _Save_ and click _View policy_
9. Click _Edit_ right next to _Assignments_
10. Under _Included groups_, click _Add groups_
11. Check all groups you want to install Myndr to and click _Select_
12. Click _Review + save_
13. Review what you did and click _Save_


### Speed up propagation
Sometimes Windows devices do not sync very quickly when theyre managed from Intune.  
To try to speed up propagation, you can do the following:

1. Click "Devices" and "All devices"
2. Click "Bulk actions for device"
3. Select "Windows", "Physical devices" and "Synchronization"
4. Click "Next" and review the devices you want to sync
5. Click "Next" and "Create"

Within a couple of hours all devices in the assigned user group should have the requirements set, the Myndr Add-on for Edge and Myndr Extension for Chrome installed.

