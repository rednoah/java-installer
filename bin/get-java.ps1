# Java Installer for OpenJDK 19.0.2


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
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jdk_x64_linux_hotspot_19.0.2_7.tar.gz"
		$JDK_SHA256 = "3a3ba7a3f8c3a5999e2c91ea1dca843435a0d1c43737bd2f6822b2f02fc52165"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/19.0.2+9/bellsoft-jdk19.0.2+9-linux-i586.tar.gz"
		$JDK_SHA256 = "c962d5c501f19072c4961a6413225e99e433112adc8459c954b994224e824b55"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jdk_aarch64_linux_hotspot_19.0.2_7.tar.gz"
		$JDK_SHA256 = "1c4be9aa173cb0deb0d215643d9509c8900e5497290b29eee4bee335fa57984f"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jdk_arm_linux_hotspot_19.0.2_7.tar.gz"
		$JDK_SHA256 = "6a51cb3868b5a3b81848a0d276267230ff3f8639f20ba9ae9ef1d386440bf1fd"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jdk_ppc64le_linux_hotspot_19.0.2_7.tar.gz"
		$JDK_SHA256 = "173d1256dfb9d13d309b5390e6bdf72d143b512201b0868f9d349d5ed3d64072"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jdk_x64_mac_hotspot_19.0.2_7.tar.gz"
		$JDK_SHA256 = "f59d4157b3b53a35e72db283659d47f14aecae0ff5936d5f8078000504299da6"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jdk_aarch64_mac_hotspot_19.0.2_7.tar.gz"
		$JDK_SHA256 = "c419330cc8d6b9974d3bf1937f8f0e747c34c469afd5c546831d35aa19e03d49"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jdk_x64_windows_hotspot_19.0.2_7.zip"
		$JDK_SHA256 = "78406ce8ca86909634b5d07b511f6e4b5c3f91fa1b841411ae1b64f0f7761839"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.2%2B7/OpenJDK19U-jdk_x86-32_windows_hotspot_19.0.2_7.zip"
		$JDK_SHA256 = "48a35009f4a3cf3ccb3006e0a72da57c1aaf3b98a635d0d8e55fc2237da3e08a"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19.0.2.1/openjfx-19.0.2.1_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "252325b8265fe6c658d6532f6a3f7c0cd49102a67e376f76ab4afc22f1b3535f"
	}
	"Linux aarch64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19.0.2.1/openjfx-19.0.2.1_linux-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "b50d460f3d4acfbc97138fa1416ac981c4773f5732cdd005ddc083010b5a8f03"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19.0.2.1/openjfx-19.0.2.1_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "13cc638345c8eaf69d0ec3992e900fecba6220250b7793da87067c239abb2b12"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19.0.2.1/openjfx-19.0.2.1_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "5f638128c29a22880e63c998070b1a5e094dec12234713698f98ed646557fca4"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19.0.2.1/openjfx-19.0.2.1_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "b7cf2cad2468842b3b78d99f6c0555771499a36fa1f1ee3dd1b9a4597f1fab86"
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
