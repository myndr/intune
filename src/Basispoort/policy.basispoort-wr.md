# Myndr intune configuration policy
## Store extension w/ requirements
Files: 
* `Myndr_Basispoort-with-requirements.policy.json`
* `Myndr_Basispoort_Beta-with-requirements.policy.json` (Only for customers in the Beta program)


## Installing in Intune

1. Log in at [Microsoft Intune ](https://intune.microsoft.com/)
2. Click _Devices_, _Windows_ and _Configuration_
3. Click _Create_ and _Import policy_
4. Drag and drop the JSON file at the designated field
5. Type "Myndr" in the _New name*_ field (Or "Myndr-Beta" if you're installing the Beta version)
6. Type "Install Myndr and configure requirements" in the _New description_ field
7. Click _Save_ and click _View policy_
8. Click _Edit_ right next to _Assignments_
9. Under _Included groups_, click _Add groups_
10. Check all groups you want to install Myndr to and click _Select_
11. Click _Review + save_
12. Review what you did and click _Save_

## Contents
The following items are configured via these files:  
__For Google Chrome__
- `googlechrome~extensions_extensioninstallforcelist` Silent/forced installation of Google Chrome extension (Myndr)
- `googlechrome~extensions_extensionsettings` Settings needed to correctly install Google Chrome extension (Myndr)
- `googlechrome_incognitomodeavailability` Disabling the incognito mode for Google Chrome
- `googlechrome~extensions_extensioninstallblocklist` Disable installing unapproved extensions in Google Chrome
- `googlechrome_managedaccountssigninrestriction` Prevent using other Google accounts to circumvent school policies
- `googlechrome_browsersignin` Prevent using a different user profile in Google Chrome to circumvent school policies
- `googlechrome_browseraddpersonenabled` Prevent addinga new profile in Google Chrome to circumvent school policies
- `googlechrome_browserguestmodeenabled` Prevent using a guest profile in Google Chrome to circumvent school policies
- `googlechrome_developertoolsavailability` Disable the use of "DevTools" in Google Chrome for any silent/forced installed extension

__For Microsoft Edge__
- `microsoft_edge~extensions_extensioninstallforcelist` Silent/forced installation of Microsoft Edge add-on (Myndr)
- `microsoft_edge~extensions_extensionsettings` Settings needed to correctly install Microsoft Edge add-on (Myndr)
- `microsoft_edge_inprivatemodeavailability` Disabling the in-private mode for Microsoft Edge
- `microsoft_edge~extensions_extensioninstallblocklist`  Disable installing unapproved extensions in Microsoft Edge
- `microsoft_edge_hubssidebarenabled` Prevent using "sidebar"
- `microsoft_edge_standalonehubssidebarenabled` Prevent using "sidebar"
- `microsoft_edge_searchinsidebarenabled` Prevent using "sidebar"
- `microsoft_edge_edgeopeninsidebarenabled` Prevent using "sidebar"
- `microsoft_edge_splitscreenenabled` Prevent using "split-screen"
- `microsoft_edge_nonremovableprofileenabled` Prevent using a different user profile in Microsoft Edge to circumvent school policies
- `microsoft_edge_developertoolsavailability` Disable the use of "DevTools" in Microsoft Edge for any silent/forced installed extension
- `microsoft_edge_browserguestmodeenabled` Prevent using a guest profile in Microsoft Edge to circumvent school policies

__For Windows__
- `allowmicrosoftaccountconnection` Prevent using private Microsoft account to circumvent school policies
- `blockmicrosoftaccounts` Prevent using private/other Microsoft account to circumvent school policies
