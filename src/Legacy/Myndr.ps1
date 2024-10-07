<#
Install Myndr extension to Edge & Chrome and set policies to increase effectiveness of laptop use in the classroom

Command: powershell.exe Myndr.ps1
Arguments:
   -crc NNNN              4 digit Classroom code
   -allowinactive 0|1     only active after individual activation

// this should always be set except when specifically wanted
   -distractions 0|1      default = 0, when set to 1 this will enable:
   # desktop notifications via WebPush
   # built-in game. Chrome: Dino, Edge: Surf
   # news on new tab in Edge,



// arguments below should normally be preset to let Myndr function correctly
// arguments should not be used
   -noprivate 1|0         disable private/incognito mode
   -noprofile 0|1         disable extra profiles
   -noextensions 1|0      disable extension install
   -noguests 1|0          disable guest mode
   -noextdev 1|0          disable dev tools on extensions
   -forcesync 0|1         force profile login and sync on browser
   -sidebar 0|1           disable sidebar in Edge


Example direct (test) usage:
powershell.exe Myndr.ps1 -crc 1234 -allowinactive 0 -distractions 0

#>



param(
  [string]$command = 'install',
  [string]$crc = '',
  [bool]$allowinactive = 0,
  [bool]$distractions = 0
)

# Configuration for Both Google Chrome and Microsoft Edge
$global:browsers = @(
  [pscustomobject]@{ id = 1; browser = 'Google\Chrome'; extID = 'afphljjmbndfchfkdpegkckkcbejepik' }
  [pscustomobject]@{ id = 2; browser = 'Microsoft\Edge'; extID = 'ioagfbkdbiaocmlmhepflbbjmalpdgod' }
)

$global:policies = @(
  ## No incognito/private windows
  ## Chrome | https://chromeenterprise.google/policies/#IncognitoModeAvailability
    [PSCustomObject]@{
      installBrowser = 1
      installParam = 1
      installLocation = "SOFTWARE\Policies\%s\"
      installName = "IncognitoModeAvailability"
      installType = 'DWord'
      installData = 00000001
    }
  ## Edge | https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#browserguestmodeenabled
    [PSCustomObject]@{
      installBrowser = 2
      installParam = 1
      installLocation = "SOFTWARE\Policies\%s\"
      installName = "InPrivateModeAvailability"
      installType = 'DWord'
      installData = 00000001
    }

  ## No extensions to be installed by user
  ## Both | https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#extensioninstallblocklist
    [PSCustomObject]@{
      installBrowser = 0
      installParam = 1
      installLocation = "SOFTWARE\Policies\%s\ExtensionInstallBlocklist"
      installName = ""
      installType = 'String'
      installData = '*'
      intallList = 1
    }

  ## No gossip/news on a new tab
  ## Edge | https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#newtabpagecontentenabled
    [PSCustomObject]@{
      installBrowser = 2
      installParam = 1
      installLocation = "SOFTWARE\Policies\%s\"
      installName = "NewTabPageContentEnabled"
      installType = 'DWord'
      installData = If ($distractions -eq 1)
      {
        00000001
      }
      Else
      {
        00000000
      }
    }

  ## No notifications
  ## Both | https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#defaultnotificationssetting
    [PSCustomObject]@{
      installBrowser = 0
      installParam = 1
      installLocation = "SOFTWARE\Policies\%s\"
      installName = "DefaultNotificationsSetting"
      installType = 'DWord'
      installData = If ($distractions -eq 1)
      {
        00000003
      }
      Else
      {
        00000002
      }
    }

  ## No browsing in Guest Mode
  ## Both | https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#browserguestmodeenabled
    [PSCustomObject]@{
      installBrowser = 0
      installParam = 1
      installLocation = "SOFTWARE\Policies\%s\"
      installName = "BrowserGuestModeEnabled"
      installType = 'DWord'
      installData = 00000000
    }

  ## No built-in game (easter-egg)
  ## Edge | https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#allowsurfgame
    [PSCustomObject]@{
      installBrowser = 2
      installParam = 1
      installLocation = "SOFTWARE\Policies\%s\"
      installName = "AllowSurfGame"
      installType = 'DWord'
      installData = If ($distractions -eq 1)
      {
        00000001
      }
      Else
      {
        00000000
      }
    }
  ## Chrome | https://chromeenterprise.google/policies/#AllowDinosaurEasterEgg
    [PSCustomObject]@{
      installBrowser = 1
      installParam = 1
      installLocation = "SOFTWARE\Policies\%s\"
      installName = "AllowDinosaurEasterEgg"
      installType = 'DWord'
      installData = If ($distractions -eq 1)
      {
        00000001
      }
      Else
      {
        00000000
      }
    }

  ## No dev-tools on extensions
  ## Both | https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#developertoolsavailability
    [PSCustomObject]@{
      installBrowser = 0
      installParam = 1
      installLocation = "SOFTWARE\Policies\%s\"
      installName = "DeveloperToolsAvailability"
      installType = 'DWord'
      installData = 00000000
    }
    
  ## Edge | https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies#hubssidebarenabled
  [PSCustomObject]@{
    installBrowser = 2
    installParam = 1
    installLocation = "SOFTWARE\Policies\%s\"
    installName = "HubsSidebarEnabled"
    installType = 'DWord'
    installData = If ($sidebar -eq 1)
    {
      00000001
    }
    Else
    {
      00000000
    }
  }
}

function Install-MyndrExtension
{
  param(
    [string]$crc = '',
    [bool]$allowinactive = 0,
    [bool]$distractions = 0
  )

  ###################################################################################################################
  # MAIN SCRIPT



  

  #Install at logged-in user level
  $loggedonUser = (Get-CimInstance -ClassName Win32_ComputerSystem).Username
  $userObj = New-Object System.Security.Principal.NTAccount($loggedonUser)
  $user = $userObj.Translate([System.Security.Principal.SecurityIdentifier]).Value

  echo "Installing Myndr for user with SID $user and for current User"

  #Install for both browsers
  $browsers | ForEach-Object {
    $browser = $_
    ## Myndr extension
    ## ================================
    $installLocation = "SOFTWARE\Policies\" + $browser.browser + "\ExtensionInstallForcelist"
    if ($browser.PSobject.Properties.Name -contains "uurl")
    {
      $installData = $browser.extID + ";" + $browser.uurl
    }
    Else
    {
      $installData = $browser.extID
    }
    ## Can be used to set managed storage
    $confLocation = "SOFTWARE\Policies\" + $browser.browser + "\3rdparty\extensions\" + $browser.extID + "\policy\"

    ## Logged-in user
    If (!(Test-Path "registry::HKEY_USERS\$user\$installLocation"))
    {
      [int]$Count = 0
      New-Item -Path "registry::HKEY_USERS\$user\$installLocation" -Force
    }
    Else
    {
      [int]$Count = (Get-Item "registry::HKEY_USERS\$user\$installLocation").Count
    }
    $installKey = $Count + 1
    $previousInstall = 0
    Get-ChildItem "registry::HKEY_USERS\$user\$installLocation" -Recurse | ForEach-Object {
      if ($_.Value -like $installData) #Check if extension already added
      {
        $previousInstall = 1
      }
    }
    If ($previousInstall -lt 1)
    {
      # Force install extension
      New-ItemProperty -Path "registry::HKEY_USERS\$user\$installLocation" -Name $installKey -Value $installData -PropertyType STRING -Force
    }

    ## Current user
    If (!(Test-Path "registry::HKEY_CURRENT_USER\$installLocation"))
    {
      [int]$Count = 0
      New-Item -Path "registry::HKEY_CURRENT_USER\$installLocation" -Force
    }
    Else
    {
      [int]$Count = (Get-Item "registry::HKEY_CURRENT_USER\$installLocation").Count
    }
    $installKey = $Count + 1
    $previousInstall = 0
    Get-ChildItem "registry::HKEY_CURRENT_USER\$installLocation" -Recurse | ForEach-Object {
      if ($_.Value -like $installData) #Check if extension already added
      {
        $previousInstall = 1
      }
    }
    If ($previousInstall -lt 1)
    {
      # Force install extension
      New-ItemProperty -Path "registry::HKEY_CURRENT_USER\$installLocation" -Name $installKey -Value $installData -PropertyType STRING -Force
    }
    

    # Set configuration for Classroom Code
    
    ## Logged-in user
    If ($crc -ne '')
    {
      If (!(Test-Path "registry::HKEY_USERS\$user\$confLocation"))
      {
        New-Item -Path "registry::HKEY_USERS\$user\$confLocation" -Force
      }
      Set-ItemProperty -Path "registry::HKEY_USERS\$user\$confLocation" -Name "ClassroomCode" -Value $crc
    }
    # Set configuration for allow No Account
    If ($allowinactive -eq 1)
    {
      If (!(Test-Path "registry::HKEY_USERS\$user\$confLocation"))
      {
        New-Item -Path "registry::HKEY_USERS\$user\$confLocation" -Force
      }
      Set-ItemProperty -Path "registry::HKEY_USERS\$user\$confLocation" -Name "InactiveAccountAllow" -Value $InactiveAccountAllow
    }

    ## Current user
    If ($crc -ne '')
    {
      If (!(Test-Path "registry::HKEY_CURRENT_USER\$confLocation"))
      {
        New-Item -Path "registry::HKEY_CURRENT_USER\$confLocation" -Force
      }
      Set-ItemProperty -Path "registry::HKEY_CURRENT_USER\$confLocation" -Name "ClassroomCode" -Value $crc
    }
    # Set configuration for allow No Account
    If ($allowinactive -eq 1)
    {
      If (!(Test-Path "registry::HKEY_CURRENT_USER\$confLocation"))
      {
        New-Item -Path "registry::HKEY_CURRENT_USER\$confLocation" -Force
      }
      Set-ItemProperty -Path "registry::HKEY_CURRENT_USER\$confLocation" -Name "InactiveAccountAllow" -Value $InactiveAccountAllow
    }
    
    
    ## ================================
    
    
    ## Policies

    $policies | ForEach-Object {
      $policy = $_
      $installLocation = $policy.installLocation.replace("%s", $browser.browser)
      $installName = $policy.installName
      $installType = $policy.installType
      $installData = $policy.installData
      $installList = $policy.intallList
      $installBrowser = $policy.installBrowser

      ## Only install policy if relevant for this browser
      if ($browser.id -eq $installBrowser -Or $installBrowser -eq 0)
      {

        ## Logged-in user
        ## Verify if registry path exists
        If (!(Test-Path "registry::HKEY_USERS\$user\$installLocation"))
        {
          [int]$Count = 0
          New-Item -Path "registry::HKEY_USERS\$user\$installLocation" -Force
        }
        Else
        {
          [int]$Count = (Get-Item "registry::HKEY_USERS\$user\$installLocation").Count
        }

        ## Current user
        ## Verify if registry path exists
        If (!(Test-Path "registry::HKEY_CURRENT_USER\$installLocation"))
        {
          [int]$Count = 0
          New-Item -Path "registry::HKEY_CURRENT_USER\$installLocation" -Force
        }
        Else
        {
          [int]$Count = (Get-Item "registry::HKEY_CURRENT_USER\$installLocation").Count
        }
        
        
        ## Logged-in user
        $installKey = $Count + 1
        $previousInstall = 0
        ## Verify if key or value exists
        Get-ChildItem "registry::HKEY_USERS\$user\$installLocation" -Recurse | ForEach-Object {
          if ($_.Name -like $installName -Or ($installList -And $_.Value -like $installData)) #Check if policy already added
          {
            $previousInstall = 1
          }
        }
        If ($previousInstall -lt 1)
        {
          # If it doesn't yet exist, install path or key
          if ($installList)
          {
            New-ItemProperty -Path "registry::HKEY_USERS\$user\$installLocation" -Name $installKey -Value $installData -PropertyType $installType -Force
          }
          Else
          {
            New-ItemProperty -Path "registry::HKEY_USERS\$user\$installLocation" -Name $installName -Value $installData -PropertyType $installType -Force
          }
        }
        else
        {
          # If it does exist and it's not a list, set the value
          if (!$installList)
          {
            Set-ItemProperty -Path "registry::HKEY_USERS\$user\$installLocation" -Name $installName -Value $installData -PropertyType $installType -Force
          }
        }
        
        ## Current user
        $installKey = $Count + 1
        $previousInstall = 0
        ## Verify if key or value exists
        Get-ChildItem "registry::HKEY_CURRENT_USER\$installLocation" -Recurse | ForEach-Object {
          if ($_.Name -like $installName -Or ($installList -And $_.Value -like $installData)) #Check if policy already added
          {
            $previousInstall = 1
          }
        }
        If ($previousInstall -lt 1)
        {
          # If it doesn't yet exist, install path or key
          if ($installList)
          {
            New-ItemProperty -Path "registry::HKEY_CURRENT_USER\$installLocation" -Name $installKey -Value $installData -PropertyType $installType -Force
          }
          Else
          {
            New-ItemProperty -Path "registry::HKEY_CURRENT_USER\$installLocation" -Name $installName -Value $installData -PropertyType $installType -Force
          }
        }
        else
        {
          # If it does exist and it's not a list, set the value
          if (!$installList)
          {
            Set-ItemProperty -Path "registry::HKEY_CURRENT_USER\$installLocation" -Name $installName -Value $installData -PropertyType $installType -Force
          }
        }

      }
    }

    ## Indicate install status

    ## Logged-in user
    If (!(Test-Path "registry::HKEY_USERS\$user\SOFTWARE\Myndr"))
    {
      New-Item -Path "registry::HKEY_USERS\$user\SOFTWARE\Myndr" -Force
      New-ItemProperty -Path "registry::HKEY_USERS\$user\SOFTWARE\Myndr" -Name "installed" -Value "1" -PropertyType STRING -Force
    }
    ## Current user
    If (!(Test-Path "registry::HKEY_CURRENT_USER\SOFTWARE\Myndr"))
    {
      New-Item -Path "registry::HKEY_CURRENT_USER\SOFTWARE\Myndr" -Force
      New-ItemProperty -Path "registry::HKEY_CURRENT_USER\SOFTWARE\Myndr" -Name "installed" -Value "1" -PropertyType STRING -Force
    }

    ## ================================
  }
}

function Test-MyndrConfiguration()
{
  
}


function Remove-ForceInstall([string]$path, [string]$id)
{
  If (Test-Path $path)
  {
    Get-Item -LiteralPath $path | ForEach-Object {
      $forcedInstall = $_
      foreach ($valueName in $forcedInstall.GetValueNames())
      {
        $value = $forcedInstall.GetValue($valueName)
        if ($value -like "$id*")
        {
          Remove-ItemProperty -Path $path -Name $valueName
          Write-Output "Removed force install from $path"
        }
      }
    }
  }
}

function Remove-Configuration([string]$path, [string]$id)
{
  $remove = @()
  If (Test-Path $path)
  {
    Get-ChildItem $path -Recurse | ForEach-Object {
      $confName = $_.PSChildName
      if ($confName -like "$id")
      {
        $remove += "$path\$confName"
      }
    }
  }
  ,$remove
}


function Uninstall-MyndrExtensions
{
  # Possible extension ID's
  $extension_ids = @(
    [pscustomobject]@{ id = 'afphljjmbndfchfkdpegkckkcbejepik' }
    [pscustomobject]@{ id = 'ioagfbkdbiaocmlmhepflbbjmalpdgod' }
    [pscustomobject]@{ id = 'mkifbbniaiblfbhcadmfchalcmkmoepo' }
  )

  # Array of paths to remove
  $toRemove = @()

  # Configuration paths for both Google Chrome and Microsoft Edge
  $installs = @(
    [pscustomobject]@{ browser = 'Google\Chrome' }
    [pscustomobject]@{ browser = 'Microsoft\Edge' }
  )

  # Repeat for both browsers
  $installs | ForEach-Object {
    $install = $_
    $installLocation = "SOFTWARE\Policies\" + $install.browser + "\ExtensionInstallForcelist"
    $confLocation = "SOFTWARE\Policies\" + $install.browser + "\3rdparty\extensions"

    $extension_ids | ForEach-Object {
      $ext_id = $_.id

      # Remove extension for current user
      Remove-ForceInstall -path "registry::HKEY_CURRENT_USER\$installLocation" -id $ext_id
      # Remove configuration for current user
      $toRemove += Remove-Configuration -path "registry::HKEY_CURRENT_USER\$confLocation" -id $ext_id

      # Remove extension for all users
      # Remove configuration and installindicator (redundant) for all users
      Get-ChildItem "registry::HKEY_USERS" | ForEach-Object {
        $user = $_.PSChildName
        Remove-ForceInstall -path "registry::HKEY_USERS\$user\$installLocation" -id $ext_id
        $toRemove += Remove-Configuration -path "registry::HKEY_USERS\$user\$confLocation" -id $ext_id
        $toRemove += "registry::HKEY_USERS\$user\SOFTWARE\Myndr"
      }
    }
  }

  # Remove current installation indicator
  $toRemove += "registry::HKEY_CURRENT_USER\SOFTWARE\Myndr"
  

  # Remove collected registry keys
  foreach ($pathName in $toRemove)
  {
    If (Test-Path $pathName)
    {
      Remove-Item -Path $pathName  -Force -Recurse
      echo "Removed configuration: $pathName"
    }
  }

}

If ( $command -eq "install" ) {
  ## Uninstall any previous instalations
  Uninstall-MyndrExtensions
  Install-MyndrExtension -crc $crc -allowinactive $allowinactive -distractions $distractions
} ElseIf ( $command -eq "uninstall" ) {
  Uninstall-MyndrExtensions
} Else {
  Echo "No action defined"
}