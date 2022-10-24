# Java Installer for OpenJDK 19


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
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19%2B36/OpenJDK19U-jdk_x64_linux_hotspot_19_36.tar.gz"
		$JDK_SHA256 = "d10becfc1ea6586180246455ee8d462875f97655416a7d7c5a1c60d0570dbc8f"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/19.0.1+11/bellsoft-jdk19.0.1+11-linux-i586.tar.gz"
		$JDK_SHA256 = "f452cd7f8b8b83a528f32c53970c6a7047323eb9a10cb5fc357ca7a062892da9"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19%2B36/OpenJDK19U-jdk_aarch64_linux_hotspot_19_36.tar.gz"
		$JDK_SHA256 = "9b5de40b0f6fe0ab32e8d035720dbbc87bf41b758ed67351ad781ca6505f5294"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19%2B36/OpenJDK19U-jdk_arm_linux_hotspot_19_36.tar.gz"
		$JDK_SHA256 = "34a786548033391de80b857fe02a9c7bd42fcb94243e7273e89012df73f1adef"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19%2B36/OpenJDK19U-jdk_ppc64le_linux_hotspot_19_36.tar.gz"
		$JDK_SHA256 = "55cc9382227433fa7cc1486a12af59d5bcbea9c40eaeae9608278e056b7d86db"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19%2B36/OpenJDK19U-jdk_x64_mac_hotspot_19_36.tar.gz"
		$JDK_SHA256 = "6ee7e6b7efa083ef7a1f206807230a0c5c1ab79609b1b27e0c97211cb01c4556"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19%2B36/OpenJDK19U-jdk_aarch64_mac_hotspot_19_36.tar.gz"
		$JDK_SHA256 = "8ab27c4038dce4be7b0f73d3e4c6c9271f8f11e7e5d9c0a0bf37505986420ccf"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19%2B36/OpenJDK19U-jdk_x64_windows_hotspot_19_36.zip"
		$JDK_SHA256 = "4384f2dbe0e6a213172f2737475ce68728281cdeb30df2b571b1429bb56c6561"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19%2B36/OpenJDK19U-jdk_x86-32_windows_hotspot_19_36.zip"
		$JDK_SHA256 = "9977ecc923e79a7ad3c1177243d047415faa174b79f9b2eaf1783023f0c9a4ab"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19/openjfx-19_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "452d030213b4df3047a5a542fc3858d4f96cba73941c5386b4b2759c4d56ba46"
	}
	"Linux aarch64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19/openjfx-19_linux-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "b85a760c1f5b6c04587d89aaf97fe8e74af615495b9e90195b4b4ff6ddc7ab03"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19/openjfx-19_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "52295b26fca577bb1147417d47cb72fc8f97f86282a0d7ac78710e9eb37a0534"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19/openjfx-19_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "95ea7c89df852fd86c2ebadf4d2c654efec759f577d6fa9e452b41dd0a25b586"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19/openjfx-19_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "fe41ccb96866cdc92e08043520bf58689ba808d6418bae6f77ca48960dc1317f"
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
