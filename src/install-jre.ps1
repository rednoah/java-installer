# @{title} for @{jdk.name} @{jdk.version}
# Example: Invoke-WebRequest "https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jre.ps1" | Invoke-Expression

# JDK version identifiers
$JDK_URL = "@{jre.windows.x64.url}"
$JDK_SHA256 = "@{jre.windows.x64.sha256}"

# fetch JDK
$JDK_TAR_GZ = Split-Path -Leaf $JDK_URL
Write-Output "Download $JDK_TAR_GZ"

if (!(test-path $JDK_TAR_GZ)) {
	$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
	$cookie = New-Object System.Net.Cookie 
	$cookie.Name = "oraclelicense"
	$cookie.Value = "accept-securebackup-cookie"
	$cookie.Domain = "oracle.com"
	$session.Cookies.Add($cookie)
	Invoke-WebRequest -WebSession $session -Uri $JDK_URL -OutFile $JDK_TAR_GZ
}

# verify archive via SHA-256 checksum
$JDK_SHA256_ACTUAL = (Get-FileHash -Algorithm SHA256 $JDK_TAR_GZ).hash.toLower()
Write-Output "Expected SHA256 checksum: $JDK_SHA256"
Write-Output "Actual SHA256 checksum: $JDK_SHA256_ACTUAL"

if ($JDK_SHA256 -ne $JDK_SHA256_ACTUAL) {
	throw "ERROR: SHA256 checksum mismatch"
}

Write-Output "OK"
