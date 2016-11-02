# Unofficial Java Installer for Oracle Java SE 1.8.0_111
# Example: Invoke-WebRequest "https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jre.ps1" | Invoke-Expression

# JDK version identifiers
$JDK_URL = "http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jre-8u111-windows-x64.tar.gz"
$JDK_SHA256 = "60140fa25ecb80825b74bbb428e99278f7c2820de15118d6d7e4d0ed737b6d60"

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
	Invoke-RestMethod -ContentType "application/octet-stream" -WebSession $session -Uri $JDK_URL  -OutFile $JDK_TAR_GZ
}

# verify archive via SHA-256 checksum
$JDK_SHA256_ACTUAL = (Get-FileHash -Algorithm SHA256 $JDK_TAR_GZ).hash.toLower()
echo "Expected SHA256 checksum: $JDK_SHA256"
echo "Actual SHA256 checksum: $JDK_SHA256_ACTUAL"

if ($JDK_SHA256 -ne $JDK_SHA256_ACTUAL) {
	throw "ERROR: SHA256 checksum mismatch"
}

echo "OK"
