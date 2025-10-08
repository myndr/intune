<#
Uninstall Myndr extension from Edge & Chrome from previous Powershell / intune win package based installs

Command: powershell.exe Remove-Myndr.ps1

Example direct (test) usage:
powershell.exe Remove-Myndr.ps1

#>

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
	# All public and enterprise/customized Myndr extension ID's
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
		[pscustomobject]@{
			id = 'ipipglooipbjinlnfckhgkgofpgkandj'
		}
		[pscustomobject]@{
			id = 'hdaikaenmgccjfeogpmefkdoenfajmlk'
		}
		[pscustomobject]@{
			id = 'dlnlnbndcijponhhcohfjnmhlcfcmhoj'
		}
		[pscustomobject]@{
			id = 'ighhbagifpldogkegacgffbneljjaoif'
		}
		[pscustomobject]@{
			id = 'cbgklfckdepkekejnkcidlibmhnimpdo'
		}
		[pscustomobject]@{
			id = 'opbikhincjepcbdkkghjgenjajleomhi'
		}
		[pscustomobject]@{
			id = 'hbdoeomalofodokghbgbdlaponhamakj'
		}
		[pscustomobject]@{
			id = 'ljjppgojfpfppbjhmieppfggbnbnajbj'
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
		$settingsLocation = "SOFTWARE\Policies\" + $install.browser + "\ExtensionSettings"

		$extension_ids | ForEach-Object {
			$ext_id = $_.id

			# Remove extension for current user
			Remove-ForceInstall -path "registry::HKEY_CURRENT_USER\$installLocation" -id $ext_id
			Remove-ForceInstall -path "registry::HKEY_LOCAL_MACHINE\$installLocation" -id $ext_id
			# Remove configuration for current user
			$toRemove += Remove-Configuration -path "registry::HKEY_CURRENT_USER\$confLocation" -id $ext_id
			$toRemove += Remove-Configuration -path "registry::HKEY_LOCAL_MACHINE\$confLocation" -id $ext_id
			# Remove extension settings for current user
			$toRemove += Remove-Configuration -path "registry::HKEY_CURRENT_USER\$settingsLocation" -id $ext_id
			$toRemove += Remove-Configuration -path "registry::HKEY_LOCAL_MACHINE\$settingsLocation" -id $ext_id

			# Remove extension for all users
			# Remove configuration and installindicator (redundant) for all users
			Get-ChildItem "registry::HKEY_USERS" | ForEach-Object {
				$user = $_.PSChildName
				Remove-ForceInstall -path "registry::HKEY_USERS\$user\$installLocation" -id $ext_id
				$toRemove += Remove-Configuration -path "registry::HKEY_USERS\$user\$confLocation" -id $ext_id
				$toRemove += Remove-Configuration -path "registry::HKEY_USERS\$user\$settingsLocation" -id $ext_id
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

Uninstall-MyndrExtensions
