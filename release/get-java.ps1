# Java Installer for OpenJDK 11.0.2


param (
	[string]$command = 'get',
	[string]$type = 'jdk',
	[string]$arch = 'x86_64'
)


$ErrorActionPreference = "Stop"


Switch ("$arch $type") {
	"x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_windows-x64_bin.zip"
		$JDK_SHA256 = "cf39490fe042dba1b61d6e9a395095279a69e70086c8c8d5466d9926d80976d8"
	}
	"x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/11.0.2/openjfx-11.0.2_windows-x64_bin-sdk.zip"
		$JDK_SHA256 = "2dd008e0c865f9bc02abd4aaf11ceeb15ca5bfe8c434e613501feda60528ce61"
	}
	default {
		throw "CPU architecture not supported."
	}
}


# fetch JDK
$JDK_TAR_GZ = Split-Path -Leaf $JDK_URL

if (!(test-path $JDK_TAR_GZ)) {
	Write-Output "Download $JDK_TAR_GZ"
	Invoke-WebRequest -UseBasicParsing -Uri $JDK_URL -OutFile $JDK_TAR_GZ
}


# verify archive via SHA-256 checksum
$JDK_SHA256_ACTUAL = (Get-FileHash -Algorithm SHA256 $JDK_TAR_GZ).hash.toLower()
Write-Output "Expected SHA256 checksum: $JDK_SHA256"
Write-Output "Actual SHA256 checksum: $JDK_SHA256_ACTUAL"

if ($JDK_SHA256 -ne $JDK_SHA256_ACTUAL) {
	throw "ERROR: SHA256 checksum mismatch"
}


# extract and link only if explicitly requested
if ($command -ne "install") {
	Write-Output "Download complete: $JDK_TAR_GZ"
	return
}


# extract zip archive
Write-Output "Extract $JDK_TAR_GZ"
Expand-Archive -Path $JDK_TAR_GZ -DestinationPath .


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
