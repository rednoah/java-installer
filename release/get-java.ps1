# Java Installer for OpenJDK 21.0.10


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
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.10%2B7/OpenJDK21U-jdk_x64_linux_hotspot_21.0.10_7.tar.gz"
		$JDK_SHA256 = "ea3b9bd464d6dd253e9a7accf59f7ccd2a36e4aa69640b7251e3370caef896a4"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.10%2B7/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.10_7.tar.gz"
		$JDK_SHA256 = "357fee29fb0d5c079f6730db98b28942df13a6eed426f6c61cd4ad703ab27b9a"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.10%2B7/OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.10_7.tar.gz"
		$JDK_SHA256 = "33bdaec351f40cc70d44e251a54c23e4dd15fed8adc041e35c57461c706cf948"
	}
	"Linux riscv64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.10%2B7/OpenJDK21U-jdk_riscv64_linux_hotspot_21.0.10_7.tar.gz"
		$JDK_SHA256 = "a57fd486c3c24ed615eb91ef9421ddd38c720e7398df5a161872fb26ad825936"
	}
	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.10%2B7/OpenJDK21U-jdk_x64_mac_hotspot_21.0.10_7.tar.gz"
		$JDK_SHA256 = "7484d5d4cdb02fc17a842ab86ddac2524a0365066659c46b2e258c64152379cd"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.10%2B7/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.10_7.tar.gz"
		$JDK_SHA256 = "01ca390455216ca27bdddf8cfad51aaedb4f90e1e23aad9bfd9e90caaa2c5f1b"
	}
	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.10%2B7/OpenJDK21U-jdk_x64_windows_hotspot_21.0.10_7.zip"
		$JDK_SHA256 = "08cae782814f027f8b159d6b68823f0f87422eb475c1a0ea1abc7a4357aaf11f"
	}
	"Windows aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.10%2B7/OpenJDK21U-jdk_aarch64_windows_hotspot_21.0.10_7.zip"
		$JDK_SHA256 = "0e1f016cd74c05ab4fe2b2a839f6439e3dc516c9bb201bfb75d12b3fb2a63334"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.10/openjfx-21.0.10_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "4f75b172da0512b7d561124830fa40dafd9421f4a36a70551a42a43729444bb1"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.10/openjfx-21.0.10_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "ce717216a584e4d7cadc8f97fdf845029ece159fe9a652ff8c303ce42c476e3b"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.10/openjfx-21.0.10_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "5e1d388a3676106c53a099e4909ea3e32796738674740eb4b7f0065de6405e03"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.10/openjfx-21.0.10_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "d118241b342d47bf50ef959dff1a89490783115579877da92c24edd178c4d273"
	}

	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.10+10/bellsoft-jdk21.0.10+10-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "e3ed2d5aa469b4eb2f0ada0bbbad294152fb609929c25203904b49405ea7096a"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.10+10/bellsoft-jdk21.0.10+10-linux-i586.tar.gz"
		$JDK_SHA256 = "73505e53a4ebd382ee77b501956e4730614fa1d29c55ebb9c7e5068c3ac97c52"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.10+10/bellsoft-jdk21.0.10+10-windows-i586.zip"
		$JDK_SHA256 = "424439c5942e1ebf5ae0d3aeb6f7a97ec54c4d7eacc6278a30b707c917ab3a54"
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
	Remove-Item -Path $JDK_TAR_GZ
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
