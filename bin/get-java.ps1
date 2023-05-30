# Java Installer for OpenJDK 17.0.7


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
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.7_7.tar.gz"
		$JDK_SHA256 = "e9458b38e97358850902c2936a1bb5f35f6cffc59da9fcd28c63eab8dbbfbc3b"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/17.0.7+7/bellsoft-jdk17.0.7+7-linux-i586.tar.gz"
		$JDK_SHA256 = "30f86d88f403b7c76b952b490963374457aa043a91b8d43bf2b85be78b965dff"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.7_7.tar.gz"
		$JDK_SHA256 = "0084272404b89442871e0a1f112779844090532978ad4d4191b8d03fc6adfade"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_arm_linux_hotspot_17.0.7_7.tar.gz"
		$JDK_SHA256 = "e7a84c3e59704588510d7e6cce1f732f397b54a3b558c521912a18a1b4d0abdc"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_ppc64le_linux_hotspot_17.0.7_7.tar.gz"
		$JDK_SHA256 = "8f4366ff1eddb548b1744cd82a1a56ceee60abebbcbad446bfb3ead7ac0f0f85"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_x64_mac_hotspot_17.0.7_7.tar.gz"
		$JDK_SHA256 = "50d0e9840113c93916418068ba6c845f1a72ed0dab80a8a1f7977b0e658b65fb"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.7_7.tar.gz"
		$JDK_SHA256 = "1d6aeb55b47341e8ec33cc1644d58b88dfdcce17aa003a858baa7460550e6ff9"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_x64_windows_hotspot_17.0.7_7.zip"
		$JDK_SHA256 = "daab0bac6681e8dbf7bce071c2d6b1b6feaf7479897871a705d10f5f0873d299"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.7%2B7/OpenJDK17U-jdk_x86-32_windows_hotspot_17.0.7_7.zip"
		$JDK_SHA256 = "1174dda2dadaf611436fd09aaef52b8dcafc1aa71b4c225e0a34ce0597d574dd"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.7/openjfx-17.0.7_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "ef1b631812ed8112558493aea0fd5d36384a2ebb9b2a000601f34b7fb0f13db0"
	}
	"Linux aarch64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.7/openjfx-17.0.7_linux-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "e46b55f2b3b7f2cf50aee4826a5187b1ed751beeeab5714e709e626bf10cf3d0"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.7/openjfx-17.0.7_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "af240a787f62d21fd898e272a4c9e395ca8da577218ade82636a66bb1d6ebd8e"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.7/openjfx-17.0.7_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "946650c909d9805c04282baabda87d58b1da2cdc5fb5f28193ca1b7f4841a180"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.7/openjfx-17.0.7_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "6c8209d66af12af24f2917b47807326a6565676deac10ac4c2bd59c7dd7e7a03"
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
