# Java Installer for OpenJDK 12.0.1


param (
	[string]$command = 'get',
	[string]$type = 'jdk',
	[string]$arch = 'x86_64',
	[string]$os = 'Windows',
	[string]$out
)


$ErrorActionPreference = "Stop"


Switch ("$os $arch $type") {
	"Linux x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "151eb4ec00f82e5e951126f572dc9116104c884d97f91be14ec11e85fc2dd626"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/12.0.1/bellsoft-jdk12.0.1-linux-i586.tar.gz"
		$JDK_SHA256 = "b267c658281f8cb3fa0cf92b2b24e34e0d41a57aab83685a9dcc8dc8680833a8"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/12.0.1/bellsoft-jdk12.0.1-linux-aarch64.tar.gz"
		$JDK_SHA256 = "037177804b80177edcbab30c5612f0fc13e611f6d9287642c831f00b9b7fe188"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/12.0.1/bellsoft-jdk12.0.1-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "f9b1e45c310f45ec3a6804345a0c64f632ac7f2ae6258cf1b7b73009a1e57651"
	}
	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "cba6f42f82496f62c51fb544e243d440984d442bdc906550a30428d8be6189e5"
	}
	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_windows-x64_bin.zip"
		$JDK_SHA256 = "fc7d9eee3c09ea6548b00ca25dbf34a348b3942c815405a1428e0bfef268d08d"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/12.0.1/bellsoft-jdk12.0.1-windows-i586.zip"
		$JDK_SHA256 = "4c39ab2aa5c246c377702693d462f17cdd5d85ca55aad0f270eda5063d95e4b0"
	}

	"Windows x86_64 jre" {
		$JDK_URL = "https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1+12/OpenJDK12U-jre_x64_windows_hotspot_12.0.1_12.zip"
		$JDK_SHA256 = "415242a5dd288fa3559a729912ff79916f5c74827c7819980912285165ad2d3a"
	}
	"Darwin x86_64 jre" {
		$JDK_URL = "https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1+12/OpenJDK12U-jre_x64_mac_hotspot_12.0.1_12.tar.gz"
		$JDK_SHA256 = "a739b9b828ee1e83830739180af1c1f070431bba3812ab4f067dfca18e163b2a"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/12.0.1/openjfx-12.0.1_linux-x64_bin-sdk.zip"
		$JDK_SHA256 = "8de2c84a5844341d140074f5070deca1f7865733ef0176a8114540a9db2e4657"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/12.0.1/openjfx-12.0.1_osx-x64_bin-sdk.zip"
		$JDK_SHA256 = "6915fcec618dda0fdb0a46bd15db11e3cafba5b213e1f818bd64543cc25abf6c"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/12.0.1/openjfx-12.0.1_windows-x64_bin-sdk.zip"
		$JDK_SHA256 = "3af29fe7d8ded403f0653d16f8da6d431c176d476b63479205b7488c14c33d98"
	}

	default {
		throw "CPU architecture not supported."
	}
}


# fetch JDK
if ($out) {
	$JDK_TAR_GZ = $out
} else {
	$JDK_TAR_GZ = Split-Path -Leaf $JDK_URL	
}


if (!(test-path $JDK_TAR_GZ)) {
	Write-Output "Download $JDK_URL"
	(New-Object System.Net.WebClient).DownloadFile($JDK_URL, $JDK_TAR_GZ)
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
