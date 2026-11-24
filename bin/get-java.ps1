# Java Installer for OpenJDK 21.0.13


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
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_x64_linux_hotspot_21.0.13.1_2.tar.gz"
		$JDK_SHA256 = "bb8a93f9ae6e7a693b2b721e85dbeff26ae1a77447985a8d7afcdd9c7cf6222e"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.13.1_2.tar.gz"
		$JDK_SHA256 = "8c72816a6b308842d5ed1f13e5826b69c567da4784f7238d7e800efa71fe54b1"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.13.1_2.tar.gz"
		$JDK_SHA256 = "4d3d75690785cf593002446005427bb3c61de163f2469343572cdcb0d258ed62"
	}
	"Linux riscv64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_riscv64_linux_hotspot_21.0.13.1_2.tar.gz"
		$JDK_SHA256 = "24b41c3ece0ec72b07f95e04f2a150f7b0c645040843d3c32299cdd1e19fcb2d"
	}
	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jdk_x64_mac_hotspot_21.0.3_9.tar.gz"
		$JDK_SHA256 = "f777103aab94330d14a29bd99f3a26d60abbab8e2c375cec9602746096721a7c"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.13.1_2.tar.gz"
		$JDK_SHA256 = "48067f2b7c958ed104a9d8a5749be7d25220b0a356b4d2d1bcfaab3e16ad0b14"
	}
	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_x64_windows_hotspot_21.0.13.1_2.zip"
		$JDK_SHA256 = "bbebea1469996b276683c9299c227b294f85c847039c82633218186a4ad4fbf2"
	}
	"Windows aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.12.1%2B1/OpenJDK21U-jdk_aarch64_windows_hotspot_21.0.12.1_1.zip"
		$JDK_SHA256 = "ccf2e51f527d542a70ba5794a600d3aac04b4e967950e227834c7566cb1bec7b"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.13.1/openjfx-21.0.13.1_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "b9d535d1e9598dd1f3ef512d5048bdf5ee4a83da687f8bcbc06e37bc900d3f6e"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.3/openjfx-21.0.3_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "0a12ad01d8450437be3608175428b336f94bc8446123e804ae99d2d09a158a76"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.13.1/openjfx-21.0.13.1_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "eb0a452f83708b40248a6fe382274d7953f51d7d185e72c27a726dd2140a6b75"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.13.1/openjfx-21.0.13.1_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "9d140905e3cd13832d6c85d7eb1029c17810d3be49f9603e0070e9b03e7f0918"
	}

	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.13.1+5/bellsoft-jdk21.0.13.1+5-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "24147b527617905d47248f2667dba4148ed4a9ddf8bf00963d83bb7743739911"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.13.1+5/bellsoft-jdk21.0.13.1+5-linux-i586.tar.gz"
		$JDK_SHA256 = "abc8d5a8c317d79a6bc922d8acc07585ba1b7c46ed3d4358d50c3f1fb57d0957"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.13.1+5/bellsoft-jdk21.0.13.1+5-windows-i586.zip"
		$JDK_SHA256 = "32e63461f95eefbefd8ebebcc84bb89b50209217280a732bbfbbc2046f9d5986"
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
