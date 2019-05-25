# Java Installer for OpenJDK 12.0.1


param (
	[string]$command = 'get',
	[string]$type = 'jdk',
	[string]$arch = 'x86_64'
)


$ErrorActionPreference = "Stop"


Switch ("$arch $type") {
	"x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_windows-x64_bin.zip"
		$JDK_SHA256 = "fc7d9eee3c09ea6548b00ca25dbf34a348b3942c815405a1428e0bfef268d08d"
	}
	"x86_64 jre" {
		$JDK_URL = "https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1+12/OpenJDK12U-jre_x64_windows_hotspot_12.0.1_12.zip"
		$JDK_SHA256 = "415242a5dd288fa3559a729912ff79916f5c74827c7819980912285165ad2d3a"
	}
	"x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/12.0.1/openjfx-12.0.1_windows-x64_bin-sdk.zip"
		$JDK_SHA256 = "3af29fe7d8ded403f0653d16f8da6d431c176d476b63479205b7488c14c33d98"
	}
	"x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/12.0.1/bellsoft-jdk12.0.1-windows-i586.zip"
		$JDK_SHA256 = "4c39ab2aa5c246c377702693d462f17cdd5d85ca55aad0f270eda5063d95e4b0"
	}
	default {
		throw "CPU architecture not supported."
	}
}


# fetch JDK
$JDK_TAR_GZ = "OpenJDK_12.0.1_$arch-$jdk.zip"

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
