# Java 8 Installer for Oracle Java SE 1.8.0_201


$ErrorActionPreference = "Stop"


# JDK version identifiers
$JDK_ARCH = "$ENV:PROCESSOR_ARCHITECTURE"

Switch ($JDK_ARCH) {
	AMD64 {
		$JDK_URL = "http://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jre-8u201-windows-x64.tar.gz"
		$JDK_SHA256 = "359894fcc97627c1177f9b3ca3f19fa5f327f0e29789abf8de6d8a9f14481d8d"
	}
	x86 {
		$JDK_URL = "http://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jre-8u201-windows-i586.tar.gz"
		$JDK_SHA256 = "dc419a2ebd838e2f3d4e0a0efb02024abad464129d5d8decb8a7b6fbde552227"
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
	Invoke-WebRequest -UseBasicParsing -WebSession $session -Uri $JDK_URL -OutFile $JDK_TAR_GZ
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
