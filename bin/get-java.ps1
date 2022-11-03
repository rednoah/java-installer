# Java Installer for OpenJDK 19.0.1


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
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.1%2B10/OpenJDK19U-jdk_x64_linux_hotspot_19.0.1_10.tar.gz"
		$JDK_SHA256 = "163da7ea140210bae97c6a4590c757858ab4520a78af0e3e33129863d4087552"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/19.0.1+11/bellsoft-jdk19.0.1+11-linux-i586.tar.gz"
		$JDK_SHA256 = "f452cd7f8b8b83a528f32c53970c6a7047323eb9a10cb5fc357ca7a062892da9"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.1%2B10/OpenJDK19U-jdk_aarch64_linux_hotspot_19.0.1_10.tar.gz"
		$JDK_SHA256 = "5e8d7b3189364afd78d936bad140dbe1e7025d4b96d530ed5536d035c21afb7c"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.1%2B10/OpenJDK19U-jdk_arm_linux_hotspot_19.0.1_10.tar.gz"
		$JDK_SHA256 = "5f404ae08d7c49f22fe04c04ec39d7e7b17cae2007b9513ad1a7a1164174898b"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.1%2B10/OpenJDK19U-jdk_ppc64le_linux_hotspot_19.0.1_10.tar.gz"
		$JDK_SHA256 = "79320712bbef13825a0aa308621006f32e54f503142737fb21ff085185a61a96"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.1%2B10/OpenJDK19U-jdk_x64_mac_hotspot_19.0.1_10.tar.gz"
		$JDK_SHA256 = "0d80a8787fa97f5fc2f0000a849b54f4d41c5b87726c29ea1de215e382c8380c"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.1%2B10/OpenJDK19U-jdk_aarch64_mac_hotspot_19.0.1_10.tar.gz"
		$JDK_SHA256 = "2be4ffbf7c59b3148886b48ecf3f7d7edb7c745917ceae2a6be145a4678bf014"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.1%2B10/OpenJDK19U-jdk_x64_windows_hotspot_19.0.1_10.zip"
		$JDK_SHA256 = "03f72bd4a14d9b4f54e27d43be06510ca5d71c51329d7b5e0637bb9715f2f6c8"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin19-binaries/releases/download/jdk-19.0.1%2B10/OpenJDK19U-jdk_x86-32_windows_hotspot_19.0.1_10.zip"
		$JDK_SHA256 = "2e70bb41b21a290abefbf2e34fce793ed2558421c221f610fedd552cac6df4b4"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19/openjfx-19_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "452d030213b4df3047a5a542fc3858d4f96cba73941c5386b4b2759c4d56ba46"
	}
	"Linux aarch64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19/openjfx-19_linux-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "b85a760c1f5b6c04587d89aaf97fe8e74af615495b9e90195b4b4ff6ddc7ab03"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19/openjfx-19_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "52295b26fca577bb1147417d47cb72fc8f97f86282a0d7ac78710e9eb37a0534"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19/openjfx-19_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "95ea7c89df852fd86c2ebadf4d2c654efec759f577d6fa9e452b41dd0a25b586"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/19/openjfx-19_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "fe41ccb96866cdc92e08043520bf58689ba808d6418bae6f77ca48960dc1317f"
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
