# Unofficial Java Installer for Oracle Java SE 1.8.0_121


$ErrorActionPreference = "Stop"


# JDK version identifiers
$JDK_ARCH = "$ENV:PROCESSOR_ARCHITECTURE"

Switch ($JDK_ARCH) {
	AMD64 {
		$JDK_URL = "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/jre-8u121-windows-x64.tar.gz"
		$JDK_SHA256 = "4b986f866777afc950e7d86f8b26399c84be1e3116875a8f44cc5946f85badbe"
	}
	x86 {
		$JDK_URL = "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/jre-8u121-windows-i586.tar.gz"
		$JDK_SHA256 = "c668cdb25e5d16c8a275c73da8cb0fa142890e37f84a3b60edc56120116e6100"
	}
	default {
		throw "CPU architecture not supported: $JDK_ARCH"
	}
}


# fetch JDK
$JDK_TAR_GZ = Split-Path -Leaf $JDK_URL

if (!(test-path $JDK_TAR_GZ)) {
	Write-Output "Download $JDK_TAR_GZ"
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


# extract and link only if explicitly requested
if ($args[0] -ne "install") {
	Write-Output "Download complete: $JDK_TAR_GZ"
	return
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
