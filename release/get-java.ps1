# Java Installer for OpenJDK 15


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
		$JDK_URL = "https://download.java.net/java/GA/jdk15/779bf45e88a44cbd9ea6621d33e33db1/36/GPL/openjdk-15_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "bb67cadee687d7b486583d03c9850342afea4593be4f436044d785fba9508fb7"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15+36/bellsoft-jdk15+36-linux-i586.tar.gz"
		$JDK_SHA256 = "4398ce560b5466a9fbd478cf4a2ed19c94056d438f9a9e033c77b80e4e390e79"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15+36/bellsoft-jdk15+36-linux-aarch64.tar.gz"
		$JDK_SHA256 = "5e8751ead7d0ab561bb6359b9be65ac0fb3db3e561111b0606fbde7f60169e64"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15+36/bellsoft-jdk15+36-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "3adab30c8d9ad8be7b26d8b2cb5ab13052959b4de40a1131d11a668c4e33ae5a"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15+36/bellsoft-jdk15+36-linux-ppc64le.tar.gz"
		$JDK_SHA256 = "f3739722858fb4011baece204b8cd54bd3b1c813e3e21c7156d641c0f6f357aa"
	}
	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk15/779bf45e88a44cbd9ea6621d33e33db1/36/GPL/openjdk-15_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "ab842c8c0953b816be308c098c1a021177a4776bef24da85b6bafbbd657c7e1a"
	}
	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk15/779bf45e88a44cbd9ea6621d33e33db1/36/GPL/openjdk-15_windows-x64_bin.zip"
		$JDK_SHA256 = "764e39a71252a9791118a31ae56a4247c049463bda5eb72497122ec50b1d07f8"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15+36/bellsoft-jdk15+36-windows-i586.zip"
		$JDK_SHA256 = "fe3b41d6821dac9a56e5b2cd2a1ec29be4ad791a8338622ef30802057b268028"
	}

	"Windows x86_64 jre" {
		$JDK_URL = "https://download.bell-sw.com/java/15+36/bellsoft-jre15+36-windows-amd64.zip"
		$JDK_SHA256 = "b87594ee77f1472f719a1252e2aadc1f766d20ca94681203f6c738efad8ce2f3"
	}
	"Darwin x86_64 jre" {
		$JDK_URL = "https://download.bell-sw.com/java/15+36/bellsoft-jre15+36-macos-amd64.zip"
		$JDK_SHA256 = "83da85dfa7686e4ba5aad38491e196f7f2866f5945d24ee4f5ad2e0e5f020974"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/15/openjfx-15_linux-x64_bin-sdk.zip"
		$JDK_SHA256 = "8b4401644094c5e5e30e7ee00334aa1d27323aa648f2e7c8d3358208c2907b50"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/15/openjfx-15_osx-x64_bin-sdk.zip"
		$JDK_SHA256 = "f7bba4097017175401cfde913b551a42a4ee331ac8526bd26a727289e7839ab4"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/15/openjfx-15_windows-x64_bin-sdk.zip"
		$JDK_SHA256 = "a7f619492c34bf823ea131e1b6605339ebe94de6168c809e27e5fa3c00e41fa7"
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
