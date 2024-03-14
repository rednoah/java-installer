# Java Installer for OpenJDK 17.0.10


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
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.10_7.tar.gz"
		$JDK_SHA256 = "a8fd07e1e97352e97e330beb20f1c6b351ba064ca7878e974c7d68b8a5c1b378"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/17.0.10+13/bellsoft-jdk17.0.10+13-linux-i586.tar.gz"
		$JDK_SHA256 = "9715485192eb120c97e2e98ae662274218451a99bad11d6d33bfd311abe58f62"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.10_7.tar.gz"
		$JDK_SHA256 = "6e4201abfb3b020c1fb899b7ac063083c271250bf081f3aa7e63d91291a90b74"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_arm_linux_hotspot_17.0.10_7.tar.gz"
		$JDK_SHA256 = "9bb8ccb9993f85d07ca3d834354ce426857793262bea8dab861b0aebb152d89c"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_ppc64le_linux_hotspot_17.0.10_7.tar.gz"
		$JDK_SHA256 = "f5fc5c9273b722ad73241a5e84feb4eba21697a57ba718dd16cfbddda45a6a4b"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_x64_mac_hotspot_17.0.10_7.tar.gz"
		$JDK_SHA256 = "e16ee89d3304bb2ba706f9a7b0ba279725c2aea55d5468336f8de4bb859f300d"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.10_7.tar.gz"
		$JDK_SHA256 = "a6ec3b94f61695e8f445ee508411c56a2ce0cabc16ea4c4296ff062d13559d92"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_x64_windows_hotspot_17.0.10_7.zip"
		$JDK_SHA256 = "fa963bc6fa54c3537c663d444c7bb4aa8ae9939cba8fadaf672311f352835060"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_x86-32_windows_hotspot_17.0.10_7.zip"
		$JDK_SHA256 = "11667e9e7bbcb980430d6cc630553162a0c18a4238c4b040bb671cd806077106"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.8/openjfx-17.0.8_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "59f32eb8f02336aeb815eb90f2f94a2eef6403c36e5c9e89635db71de3ce5c93"
	}
	"Linux aarch64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.8/openjfx-17.0.8_linux-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "0a5021d897585735d8d0a1c757aae8e213754a94e3439bf81a0060e16e9308d2"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.8/openjfx-17.0.8_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "f38c6effcf1de2580532b6dbff1229800b07f01286e537c2799a1a95f9ecb593"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.8/openjfx-17.0.8_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "d225e9cc77bb9a6548b7652714ba4ea4ed20c2d1caee397468946f0dede56f6c"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.8/openjfx-17.0.8_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "55e0b7a674b99c2fa1bfbc36a5ece7d4b58009d30268ab0f97d4e31a3921a8be"
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
