# Java Installer for OpenJDK 17.0.8


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
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz"
		$JDK_SHA256 = "aa5fc7d388fe544e5d85902e68399d5299e931f9b280d358a3cbee218d6017b0"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/17.0.8+7/bellsoft-jdk17.0.8+7-linux-i586.tar.gz"
		$JDK_SHA256 = "0a14bcdbbaec3c0d6f03491335689aa2445f773936ebb9bcca33e96a37ca1a47"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.8_7.tar.gz"
		$JDK_SHA256 = "c43688163cfdcb1a6e6fe202cc06a51891df746b954c55dbd01430e7d7326d00"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_arm_linux_hotspot_17.0.8_7.tar.gz"
		$JDK_SHA256 = "33d972efd78b70a07aed793a6ebcb52a5129707e8c62268e478d1c2df15898e1"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_ppc64le_linux_hotspot_17.0.8_7.tar.gz"
		$JDK_SHA256 = "88f5d14cc84a4bcfe50aa275092ae97a0edf7205269ed12c1972bf613bc52b1e"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_x64_mac_hotspot_17.0.8_7.tar.gz"
		$JDK_SHA256 = "6fea89cea64a0f56ecb9e5d746b4921d2b0a80aa65c92b265ee9db52b44f4d93"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.8_7.tar.gz"
		$JDK_SHA256 = "105d1ada42927fccde215e8c80b43221cd5aad42e6183819c367234ac062fc10"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_x64_windows_hotspot_17.0.8_7.zip"
		$JDK_SHA256 = "341a7243778802019a100ba7ae32a05a3f4ae5fd64dbf2a970d02f07c7d1c804"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8%2B7/OpenJDK17U-jdk_x86-32_windows_hotspot_17.0.8_7.zip"
		$JDK_SHA256 = "12f210d6beb3c3573c14525242144aae15cdc27f29401698a065375eab0c91d0"
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
