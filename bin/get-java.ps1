# Java Installer for OpenJDK 21.0.9


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
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_x64_linux_hotspot_21.0.9_10.tar.gz"
		$JDK_SHA256 = "810d3773df7e0d6c4394e4e244b264c8b30e0b05a0acf542d065fd78a6b65c2f"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.9+11/bellsoft-jdk21.0.9+11-linux-i586.tar.gz"
		$JDK_SHA256 = "8f1f883a4dcc9076367a89f290eb69a0249943bd540ce046982846aa54bea51c"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.9_10.tar.gz"
		$JDK_SHA256 = "edf0da4debe7cf475dbe320d174d6eed81479eb363f41e38a2efb740428c603a"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.9+11/bellsoft-jdk21.0.9+11-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "ae2d3e750496da6d5fd467c5c7e0d2146bdcdd8ad9aa902a09fbdfc3cb542e86"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.9_10.tar.gz"
		$JDK_SHA256 = "ac5a0394a234269b4e20459649ac93cb702cde29b3e46a0bcf3aa53958f2d4a4"
	}
	"Linux riscv64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_riscv64_linux_hotspot_21.0.9_10.tar.gz"
		$JDK_SHA256 = "ac411d52862fe8a4a48a6c3546bebced8f4879cd728746fc4ee4b06151aa9f8b"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_x64_mac_hotspot_21.0.9_10.tar.gz"
		$JDK_SHA256 = "f803a3f5bce141f23ac699dfcda06a721f4b74f53bacb0f4bbe9bfcad54427d8"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.9_10.tar.gz"
		$JDK_SHA256 = "55a40abeb0e174fdc70f769b34b50b70c3967e0b12a643e6a3e23f9a582aac16"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_x64_windows_hotspot_21.0.9_10.zip"
		$JDK_SHA256 = "1c67df516e9795c0b09f5714bfe151da2e3cc988082042f5bbb60d75e4e63fb5"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.9+11/bellsoft-jdk21.0.9+11-windows-i586.zip"
		$JDK_SHA256 = "3d1d25c234fb53dcca94fc9a13f821e0b314232e7d854e174e3770879cf25908"
	}
	"Windows aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.9+11/bellsoft-jdk21.0.9+11-windows-aarch64.zip"
		$JDK_SHA256 = "b963ae881d0ca2659447b85cac1e4f8efb15e5b397dec38c4917951d4e12d0b4"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.9/openjfx-21.0.9_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "44d718a6118815aadfa2510454e8fd9cd71af4796499477820272daa970dbfd5"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.9/openjfx-21.0.9_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "a1d4cea780dbe8a51b48a5bf4caa4b5f6cfd40b40db61ac25005c9db44d30af4"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.9/openjfx-21.0.9_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "f64d4e65f51f7d6b302608fb04814d981c07d369fe55e99d14e0b16941f6399b"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.9/openjfx-21.0.9_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "ece676af80d7408e0a130dd77495acb61c70434ea42bd29380df32bcf9d8354b"
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
