# Java Installer for OpenJDK 18.0.2


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
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2%2B9/OpenJDK18U-jdk_x64_linux_hotspot_18.0.2_9.tar.gz"
		$JDK_SHA256 = "5e5dbf6f1308829528778e00631ec83e252d90fc444503091e71a66465e88941"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/18.0.2+10/bellsoft-jdk18.0.2+10-linux-i586.tar.gz"
		$JDK_SHA256 = "e163f16eea369d40ad24e45d0b129063ca01a7dc725e5e1e703923292d8a419d"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2%2B9/OpenJDK18U-jdk_aarch64_linux_hotspot_18.0.2_9.tar.gz"
		$JDK_SHA256 = "f4aca720bfcea4df7f02b59de1f68648632070c492f210b9e41e69170ee5e48f"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2%2B9/OpenJDK18U-jdk_arm_linux_hotspot_18.0.2_9.tar.gz"
		$JDK_SHA256 = "52ec0ddee9ff16397de2c9f614ff6b5464220bd5c3d705e8b89d28fd478feb60"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2%2B9/OpenJDK18U-jdk_ppc64le_linux_hotspot_18.0.2_9.tar.gz"
		$JDK_SHA256 = "4262677f8b6054d26f1c0042ac47dfbaab6a18d7dc73fa807b15ee03cdcbdece"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2%2B9/OpenJDK18U-jdk_x64_mac_hotspot_18.0.2_9.tar.gz"
		$JDK_SHA256 = "f96196e9eddad09544733af46d33ac5d5a44178316248e0b907c7f6cd4955bcb"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2%2B9/OpenJDK18U-jdk_aarch64_mac_hotspot_18.0.2_9.tar.gz"
		$JDK_SHA256 = "d84ec85a9e6b5e22f6bac7e96cc764f5369da393ab233149bfbcbacf1e7de9b7"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2%2B9/OpenJDK18U-jdk_x64_windows_hotspot_18.0.2_9.zip"
		$JDK_SHA256 = "09cfeba06d41637afaf29a92964d61e9a2c98fe70a10e5648846104c8714ff75"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2%2B9/OpenJDK18U-jdk_x86-32_windows_hotspot_18.0.2_9.zip"
		$JDK_SHA256 = "fbaa6fdbf4b6878682282337f55f8487c8198b8e4599ab60ed0c5ec88e626627"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/18.0.2/openjfx-18.0.2_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "7abb2bbdfdd7c9f90c9334f2a89a507fe30229bd9404c8cbf3e142fa113d3f45"
	}
	"Linux aarch64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/18.0.2/openjfx-18.0.2_linux-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "acf2c28ffd3a8ac1673a57948982635444eb0ff7d20d16d342dfbfc6a48cde66"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/18.0.2/openjfx-18.0.2_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "f6c60796e0cbd9fe59292b2d84bd6eb074943354cb9d48e0ac687a37c262e57d"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/18.0.2/openjfx-18.0.2_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "f8b768d873ebe81950442f6534cadcd7a77019bc31fa90fe1cd4131ca3d3aed4"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/18.0.2/openjfx-18.0.2_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "059df40ccee6fa3237eca134ad1979f6ea0387a134a813d6ccd7e15043f6496c"
	}

	default {
		throw "Architecture not supported: $os $arch $type"
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
