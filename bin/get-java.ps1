# Java Installer for OpenJDK 17.0.1


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
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_linux_hotspot_17.0.1_12.tar.gz"
		$JDK_SHA256 = "6ea18c276dcbb8522feeebcfc3a4b5cb7c7e7368ba8590d3326c6c3efc5448b6"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/17.0.1+12/bellsoft-jdk17.0.1+12-linux-i586.tar.gz"
		$JDK_SHA256 = "7dda1aac55e66e962d32c1a4661360b05c891645197f785f2052fafc9a0d350b"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.1_12.tar.gz"
		$JDK_SHA256 = "f23d482b2b4ada08166201d1a0e299e3e371fdca5cd7288dcbd81ae82f3a75e3"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_arm_linux_hotspot_17.0.1_12.tar.gz"
		$JDK_SHA256 = "f5945a39929384235e7cb1c57df071b8c7e49274632e2a54e54b2bad05de21a5"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_ppc64le_linux_hotspot_17.0.1_12.tar.gz"
		$JDK_SHA256 = "bd65d4e8ecc4236924ae34d2075b956799abca594021e1b40c36aa08a0d610b0"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_mac_hotspot_17.0.1_12.tar.gz"
		$JDK_SHA256 = "98a759944a256dbdd4d1113459c7638501f4599a73d06549ac309e1982e2fa70"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.1_12.tar.gz"
		$JDK_SHA256 = "02073590da24421e119ddebe6b061bf132fa68694c60706f092d32d963822554"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_windows_hotspot_17.0.1_12.zip"
		$JDK_SHA256 = "e5419773052ac6479ff211d5945f8625e0cdb036e69c0f71affaf02d5dc9aa0b"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x86-32_windows_hotspot_17.0.1_12.zip"
		$JDK_SHA256 = "604919b02caa5506e8c68888d6410384234e9a9fb0dbc6a0d97eb7652da4cf66"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "28662b6fcdaedaaf23ee6dbef2d632bf2a53e30aaa9231f27e00e6ceb10238a0"
	}
	"Linux aarch64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_linux-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "40525cc333f48acbc62657f5cfbc30635940c4bc61d42f6a1e19ab3e208b2744"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "836f8c88235d2f38b0922b4b2949e35071e9e0a7c1d22a0bebc67b476885b56b"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "90c922bdf87686b81deadbffd5c75186f92851852df333b870bf61e98e04c190"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "a9b8dbd6b67081470d7b4204af2b7ffb6130c07daf1e2967eec7c9342f6d2caf"
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
