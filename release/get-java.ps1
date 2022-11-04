# Java Installer for OpenJDK 17.0.5


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
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.5%2B8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.5_8.tar.gz"
		$JDK_SHA256 = "482180725ceca472e12a8e6d1a4af23d608d78287a77d963335e2a0156a020af"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/17.0.5+8/bellsoft-jdk17.0.5+8-linux-i586.tar.gz"
		$JDK_SHA256 = "0edf4722b22154882f049becf6a5924f3228754462dc96d4d78129186cb747eb"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.5%2B8/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.5_8.tar.gz"
		$JDK_SHA256 = "1c26c0e09f1641a666d6740d802beb81e12180abaea07b47c409d30c7f368109"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.5%2B8/OpenJDK17U-jdk_arm_linux_hotspot_17.0.5_8.tar.gz"
		$JDK_SHA256 = "e7c81596f67b6325036e9182d012f2266ced5663c5d4b0de0540ce62dcc67718"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.5%2B8/OpenJDK17U-jdk_ppc64le_linux_hotspot_17.0.5_8.tar.gz"
		$JDK_SHA256 = "a426a4e2cbc29f46fa686bea8b26613f7b7a9a772a77fed0d40dfe05295be883"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.5%2B8/OpenJDK17U-jdk_x64_mac_hotspot_17.0.5_8.tar.gz"
		$JDK_SHA256 = "94fe50982b09a179e603a096e83fd8e59fd12c0ae4bcb37ae35f00ef30a75d64"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.5%2B8/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.5_8.tar.gz"
		$JDK_SHA256 = "2dc3e425b52d1cd2915d93af5e468596b9e6a90112056abdcebac8b65bf57049"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.5%2B8/OpenJDK17U-jdk_x64_windows_hotspot_17.0.5_8.zip"
		$JDK_SHA256 = "3cdcd859c8421a0681e260dc4fbf46b37fb1211f47beb2326a00398ecc52fde0"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.5%2B8/OpenJDK17U-jdk_x86-32_windows_hotspot_17.0.5_8.zip"
		$JDK_SHA256 = "a8bb5b5e56b8ab91d4f3d40f193ca97dd16df270e3a3256b38d825fad6c4ef38"
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
