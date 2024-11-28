<#
Install Myndr Basispoort extension to Edge & Chrome

Command: powershell.exe Myndr-BP.ps1 -command install
Arguments:

			-command			install | uninstall


Example direct (test) usage:
powershell.exe Myndr-BP.ps1 -command install

#>



param(
	[string]$command = 'install'
)

# Configuration for Both Google Chrome and Microsoft Edge
$global:browsers = @(
	[pscustomobject]@{
		id = 1;
		browser = 'Google\Chrome';
		extID = 'hmgiofkfdfmocnbdlaieodfpmlpockka' ;
		pin_word = 'toolbar_pin';
		pin_state = 'force_pinned'
	}
	# As long as the extension is not in the store:
	[pscustomobject]@{
		id = 2;
		browser = 'Microsoft\Edge';
		extID = 'ighhbagifpldogkegacgffbneljjaoif' ;
		uurl = 'https://iswit.ch/';
		pin_word = 'toolbar_state';
		pin_state = 'force_shown'
	}
	# Once the extension IS in the store:
#	[pscustomobject]@{
#		id = 2;
#		browser = 'Microsoft\Edge';
#		extID = 'nfggfbiabomkkkeeflcbkakpilammmhn' ;
#		pin_word = 'toolbar_state';
#		pin_state = 'force_shown'
#	}
)

function Install-MyndrExtension
{

	###################################################################################################################
	# MAIN SCRIPT

	#Install at local machine level
	Write-Output "Installing Myndr for local machine"

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

		## Local machine

		## Create path if it doesn't exist
		If (!(Test-Path "registry::HKEY_LOCAL_MACHINE\$installLocation"))
		{
			New-Item -Path "registry::HKEY_LOCAL_MACHINE\$installLocation" -Force
			$installKey = 1
		}
		Else
		{
			[int]$installKey = 1 + (Get-Item "registry::HKEY_LOCAL_MACHINE\$installLocation").Count
		}
		$previousInstall = 0
		Get-ChildItem "registry::HKEY_LOCAL_MACHINE\$installLocation" -Recurse | ForEach-Object {
			if ($_.Value -like $installData) #Check if extension already added
			{
				$previousInstall = 1
			}
		}
		If ($previousInstall -lt 1)
		{
			# Force install extension
			New-ItemProperty -Path "registry::HKEY_LOCAL_MACHINE\$installLocation" -Name $installKey -Value $installData -PropertyType STRING -Force
		}


		$confLocation = "SOFTWARE\Policies\" + $browser.browser + "\ExtensionSettings\" + $browser.extID

		If (!(Test-Path "registry::HKEY_LOCAL_MACHINE\$confLocation"))
		{
			New-Item -Path "registry::HKEY_LOCAL_MACHINE\$confLocation" -Force
		}
		## Pin to bar
		New-ItemProperty -Path "registry::HKEY_LOCAL_MACHINE\$confLocation" -Name $browser.pin_word -Value $browser.pin_state -PropertyType STRING -Force

		## Ext url
		if ($browser.PSobject.Properties.Name -contains "uurl")
		{
			New-ItemProperty -Path "registry::HKEY_LOCAL_MACHINE\$confLocation" -Name "update_url" -Value $browser.uurl -PropertyType STRING -Force
			New-ItemProperty -Path "registry::HKEY_LOCAL_MACHINE\$confLocation" -Name "override_update_url" -Value "1" -PropertyType STRING -Force
			New-ItemProperty -Path "registry::HKEY_LOCAL_MACHINE\$confLocation" -Name "installation_mode" -Value "force_installed" -PropertyType STRING -Force
		}

		## ================================
	}
}

function Test-MyndrInstall()
{
	$result = 0
	$b_type = 1
	#Check for both browsers
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

		## Local machine

		## Check path
		If (!(Test-Path "registry::HKEY_LOCAL_MACHINE\$installLocation"))
		{
			## Doesn't exist, not installed...
			$result += $b_type
		}
		Else
		{
			Get-ChildItem "registry::HKEY_LOCAL_MACHINE\$installLocation" -Recurse | ForEach-Object {
				if ($_.Value -like $installData) #Check if extension already added
				{
					$result += $b_type
					break
				}
			}
		}
		$b_type = 2 * $b_type
	}
	return $result
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
	#Install at local machine level
	Write-Output "Uninstalling old Myndr packages"

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
			id = 'ighhbagifpldogkegacgffbneljjaoif'
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
		$confLocation = "SOFTWARE\Policies\" + $install.browser + "\ExtensionSettings\"

		$extension_ids | ForEach-Object {
			$ext_id = $_.id

			# Remove extension for local machine
			Remove-ForceInstall -path "registry::HKEY_LOCAL_MACHINE\$installLocation" -id $ext_id

			# Remove configuration for local machine
			$toRemove += "registry::HKEY_LOCAL_MACHINE\$confLocation\$ext_id"

		}
	}

	# Remove collected registry keys
	foreach ($pathName in $toRemove)
	{
		If (Test-Path $pathName)
		{
			Remove-Item -Path $pathName  -Force -Recurse
			Write-Output "Removed configuration: $pathName"
		}
	}
	If ($toRemove.Count -gt 0) {
		Write-Output "Uninstalled previous installations"
	} Else {
		Write-Output "No previous installations found"
	}
}

If ($command -eq "install")
{
	## Uninstall any previous instalations & configurations
	Uninstall-MyndrExtensions
	## Fresh install
	Install-MyndrExtension
}
ElseIf ( $command -eq "uninstall" )
{
	Uninstall-MyndrExtensions
}
Else
{
	Write-Output "No action defined"
}