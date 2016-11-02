# @{title} for @{jdk.name} @{jdk.version}
# Example: Invoke-WebRequest "https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jre.ps1" | Invoke-Expression

# JDK version identifiers
$JDK_URL = "@{jre.windows.x64.url}"
$JDK_SHA256 = "@{jre.windows.x64.sha256}"

# fetch JDK
$JDK_TAR_GZ = Split-Path -Leaf $JDK_URL
echo "Download $JDK_TAR_GZ"

if (!(test-path $JDK_TAR_GZ)) {
	$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
	$cookie = New-Object System.Net.Cookie 
	$cookie.Name = "oraclelicense"
	$cookie.Value = "accept-securebackup-cookie"
	$cookie.Domain = "oracle.com"
	$session.Cookies.Add($cookie)
	Invoke-WebRequest $JDK_URL -WebSession $session -OutFile $JDK_TAR_GZ
}

# verify archive via SHA-256 checksum
$JDK_SHA256_ACTUAL = (Get-FileHash -Algorithm SHA256 $JDK_TAR_GZ).hash.toLower()
echo "Expected SHA256 checksum: $JDK_SHA256"
echo "Actual SHA256 checksum: $JDK_SHA256_ACTUAL"

if ( $JDK_SHA256 -ne $JDK_SHA256_ACTUAL ) {
	echo "ERROR: SHA256 checksum mismatch"
	exit 1
}

echo "OK"
exit 0
