# Unofficial Java Installer for Oracle Java SE 1.8.0_111
# Example: Invoke-WebRequest https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jre.ps1 | Invoke-Expression

$ErrorActionPreference = "Stop"

# JDK version identifiers
Switch ($ENV:PROCESSOR_ARCHITECTURE) {
	AMD64 {
		$JDK_URL = "http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jre-8u111-windows-x64.tar.gz"
		$JDK_SHA256 = "60140fa25ecb80825b74bbb428e99278f7c2820de15118d6d7e4d0ed737b6d60"
	}
	x86 {
		$JDK_URL = "http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jre-8u111-windows-i586.tar.gz"
		$JDK_SHA256 = "9b039bcb5a78d850fb5bea5ce3cb47ae98d7c58f3e61714bd39050f206138b68"
	}
	default {
		throw "CPU architecture not supported: $ENV:PROCESSOR_ARCHITECTURE"
	}
}


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


# use 7-Zip to extract tar
Write-Output "Extract $JDK_TAR_GZ"
& 7z e -aos $JDK_TAR_GZ
& 7z x -aos ([System.IO.Path]::GetFileNameWithoutExtension($JDK_TAR_GZ))


# find java executable
$JAVA_EXE = Get-ChildItem -recurse -include java.exe | Sort-Object LastWriteTime | Select-Object -ExpandProperty FullName -Last 1

# test
Write-Output "Execute ""$JAVA_EXE"" -XshowSettings -version"
& $JAVA_EXE -XshowSettings -version


# set %JAVA_HOME% and add java to %PATH%
$JAVA_HOME = Split-Path -Parent (Split-Path -Parent $JAVA_EXE)

Write-Output "`nPlease add JAVA_HOME\bin to the PATH if you have not done so already:"
Write-Output "`n`t%JAVA_HOME%\bin"
Write-Output "`nPlease set JAVA_HOME:"
Write-Output "`n`tsetx JAVA_HOME ""$JAVA_HOME"""
