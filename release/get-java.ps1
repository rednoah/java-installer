# Java Installer for OpenJDK 21.0.3


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
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jdk_x64_linux_hotspot_21.0.3_9.tar.gz"
		$JDK_SHA256 = "fffa52c22d797b715a962e6c8d11ec7d79b90dd819b5bc51d62137ea4b22a340"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.3+10/bellsoft-jdk21.0.3+10-linux-i586.tar.gz"
		$JDK_SHA256 = "9379b368034b095cf0af15b6aa5a6a3548cd1e3aef32e8db6a7409fd3de12375"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.3_9.tar.gz"
		$JDK_SHA256 = "7d3ab0e8eba95bd682cfda8041c6cb6fa21e09d0d9131316fd7c96c78969de31"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.3+10/bellsoft-jdk21.0.3+10-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "cdb909ec6afe0a0a003e5214904cf6efae967150649ae351c54fe40487317fb0"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.3_9.tar.gz"
		$JDK_SHA256 = "9a1079d7f0fc72951fdc9a0029e49a15f6ba114683aee626f882ee2c761f1d57"
	}
	"Linux riscv64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jdk_riscv64_linux_hotspot_21.0.3_9.tar.gz"
		$JDK_SHA256 = "246acb1db3ef69a7e3328fa378513b2e606e64710626ae8dd29decc0e525359b"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jdk_x64_mac_hotspot_21.0.3_9.tar.gz"
		$JDK_SHA256 = "f777103aab94330d14a29bd99f3a26d60abbab8e2c375cec9602746096721a7c"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.3_9.tar.gz"
		$JDK_SHA256 = "b6be6a9568be83695ec6b7cb977f4902f7be47d74494c290bc2a5c3c951e254f"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jdk_x64_windows_hotspot_21.0.3_9.zip"
		$JDK_SHA256 = "c43a66cff7a403d56c5c5e1ff10d3d5f95961abf80f97f0e35380594909f0e4d"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.3+10/bellsoft-jdk21.0.3+10-windows-i586.zip"
		$JDK_SHA256 = "8dd427b20d6f8bcb66d43bbd6a4dc5b5433f9554a38017d1b1cc6a8c0568387d"
	}
	"Windows aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.3+10/bellsoft-jdk21.0.3+10-windows-aarch64.zip"
		$JDK_SHA256 = "ac148b0fbfe253bcd449399371a6bd491f9f23a0a67b3bd920657e4f9470578a"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.3/openjfx-21.0.3_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "62c92a586a53c7169b8cdbc1a21b86be0c438e2e8786c4df11bfcb2cca69aa8f"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.3/openjfx-21.0.3_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "0a12ad01d8450437be3608175428b336f94bc8446123e804ae99d2d09a158a76"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.3/openjfx-21.0.3_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "61e78370159e22902ce5a8224e278d02a9f1471aff56e2cef0fba30709a07d21"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.3/openjfx-21.0.3_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "f66cb1b4f027164544b059c3aed503890df94602163740236e2f3c2fab0cb0cd"
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
