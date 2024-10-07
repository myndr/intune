<#
Install Myndr extension to Edge & Chrome to increase effectiveness of laptop use in the classroom

Command: powershell.exe Myndr.ps1
Arguments:
   -crc NNNN              4 digit Classroom code
   -allowinactive 0|1     only active after individual activation
   -level                 machine(default)|user

Example direct (test) usage:
powershell.exe Myndr.ps1 -crc 1234 -allowinactive 0 -level machine

#>



param(
	[string]$command = 'install',
	[string]$crc = '',
	[bool]$allowinactive = 0,
	[string]$level = 'machine'
)

# Configuration for Both Google Chrome and Microsoft Edge
$global:browsers = @(
	[pscustomobject]@{
		id = 1; browser = 'Google\Chrome';
		extID = 'afphljjmbndfchfkdpegkckkcbejepik';
		pin_word = 'toolbar_pin';
		pin_state = 'force_pinned'
	}
	[pscustomobject]@{
		id = 2;
		browser = 'Microsoft\Edge';
		extID = 'ioagfbkdbiaocmlmhepflbbjmalpdgod';
		pin_word = 'toolbar_state';
		pin_state = 'force_shown'
	}
)

function Install-MyndrExtension
{
	param(
		[string]$crc = '',
		[bool]$allowinactive = 0,
		[string]$level = ''
	)

	###################################################################################################################
	# MAIN SCRIPT

	if ($level -eq "user")
	{
		#Install at logged-in user level
		$loggedonUser = (Get-CimInstance -ClassName Win32_ComputerSystem).Username
		$userObj = New-Object System.Security.Principal.NTAccount($loggedonUser)
		$user = $userObj.Translate([System.Security.Principal.SecurityIdentifier]).Value
		## Logged-in user path
		$tpath = "registry::HKEY_USERS\$user"
		Write-Output "Installing Myndr for user with SID $user and for current User"
	}
	else
	{
		## machine path
		$tpath = "registry::HKEY_LOCAL_MACHINE"
		Write-Output "Installing Myndr for machine"
	}


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

		## Used to set pin state
		$pinLocation = "SOFTWARE\Policies\" + $browser.browser + "\ExtensionSettings\" + $browser.extID

		If (!(Test-Path "$tpath\$installLocation"))
		{
			[int]$Count = 0
			New-Item -Path "$tpath\$installLocation" -Force
		}
		Else
		{
			[int]$Count = (Get-Item "$tpath\$installLocation").Count
		}
		$installKey = $Count + 1
		$previousInstall = 0
		Get-ChildItem "$tpath\$installLocation" -Recurse | ForEach-Object {
			if ($_.Value -like $installData) #Check if extension already added
			{
				$previousInstall = 1
			}
		}
		If ($previousInstall -lt 1)
		{
			# Force install extension
			New-ItemProperty -Path "$tpath\$installLocation" -Name $installKey -Value $installData -PropertyType STRING -Force
		}

		if ($level -eq "user")
		{
			## Also set for Current user
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
		}


		# Set configuration for Classroom Code

		## Machine level or Logged-in user
		If ($crc -ne '')
		{
			If (!(Test-Path "$tpath\$confLocation"))
			{
				New-Item -Path "$tpath\$confLocation" -Force
			}
			Set-ItemProperty -Path "$tpath\$confLocation" -Name "ClassroomCode" -Value $crc
		}
		# Set configuration for allow No Account
		If ($allowinactive -eq 1)
		{
			If (!(Test-Path "$tpath\$confLocation"))
			{
				New-Item -Path "$tpath\$confLocation" -Force
			}
			Set-ItemProperty -Path "$tpath\$confLocation" -Name "InactiveAccountAllow" -Value $InactiveAccountAllow
		}

		if ($level -eq "user")
		{
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
		}

		## Pin, can be done at machine level because it should count for all that have the extension installed
		If (!(Test-Path "registry::HKEY_LOCAL_MACHINE\$pinLocation"))
		{
			New-Item -Path "registry::HKEY_LOCAL_MACHINE\$pinLocation" -Force
		}
		New-ItemProperty -Path "registry::HKEY_LOCAL_MACHINE\$pinLocation" -Name $browser.pin_word -Value $browser.pin_state -PropertyType STRING -Force

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
		[pscustomobject]@{
			id = 'afphljjmbndfchfkdpegkckkcbejepik'
		}
		[pscustomobject]@{
			id = 'ioagfbkdbiaocmlmhepflbbjmalpdgod'
		}
		[pscustomobject]@{
			id = 'mkifbbniaiblfbhcadmfchalcmkmoepo'
		}
		[pscustomobject]@{
			id = 'bgoljgoooefjbaeojjfefbabkhcnhojg'
		}
		[pscustomobject]@{
			id = 'hmgiofkfdfmocnbdlaieodfpmlpockka'
		}
		[pscustomobject]@{
			id = 'gefgignjfgonchhgoinfdgbioakdlmkj'
		}
		[pscustomobject]@{
			id = 'nfggfbiabomkkkeeflcbkakpilammmhn'
		}
	)

	# Array of paths to remove
	$toRemove = @()

	# Configuration paths for both Google Chrome and Microsoft Edge
	$installs = @(
		[pscustomobject]@{
			browser = 'Google\Chrome'
		}
		[pscustomobject]@{
			browser = 'Microsoft\Edge'
		}
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
			Remove-ForceInstall -path "registry::HKEY_LOCAL_MACHINE\$installLocation" -id $ext_id
			# Remove configuration for current user
			$toRemove += Remove-Configuration -path "registry::HKEY_CURRENT_USER\$confLocation" -id $ext_id
			$toRemove += Remove-Configuration -path "registry::HKEY_LOCAL_MACHINE\$confLocation" -id $ext_id

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
			Write-Output "Removed configuration: $pathName"
		}
	}

}

If ($command -eq "install")
{
	## Uninstall any previous instalations
	Uninstall-MyndrExtensions
	Install-MyndrExtension -crc $crc -allowinactive $allowinactive -level $level
}
ElseIf ( $command -eq "uninstall" )
{
	Uninstall-MyndrExtensions
}
Else
{
	Write-Output "No action defined"
}