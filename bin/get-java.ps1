# Java Installer for OpenJDK 18.0.2.1


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
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2.1%2B1/OpenJDK18U-jdk_x64_linux_hotspot_18.0.2.1_1.tar.gz"
		$JDK_SHA256 = "7d6beba8cfc0a8347f278f7414351191a95a707d46b6586e9a786f2669af0f8b"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/18.0.2.1+1/bellsoft-jdk18.0.2.1+1-linux-i586.tar.gz"
		$JDK_SHA256 = "1764b595ffc8cec36b4b6a895b2de3bb7fc3a69b1cc9360056659e9641c249c0"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2.1%2B1/OpenJDK18U-jdk_aarch64_linux_hotspot_18.0.2.1_1.tar.gz"
		$JDK_SHA256 = "262be608e266fd76d7496af83b2832be853c3aaf7460d6a4da198cd40db74553"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2.1%2B1/OpenJDK18U-jdk_arm_linux_hotspot_18.0.2.1_1.tar.gz"
		$JDK_SHA256 = "4cd49b92d13847bfad7b3bf635cca349e2c89c7641748c5288bc40d612cdbbd6"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2.1%2B1/OpenJDK18U-jdk_ppc64le_linux_hotspot_18.0.2.1_1.tar.gz"
		$JDK_SHA256 = "030261a2189a8f773fda543a85ab9beb4c430bf81ca5be37cf6cb970b5ccbb03"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2.1%2B1/OpenJDK18U-jdk_x64_mac_hotspot_18.0.2.1_1.tar.gz"
		$JDK_SHA256 = "2ed916b0c9d197a6bf71b76e84d94125023c2609e0a9b22c64553eff5c9c29c1"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2.1%2B1/OpenJDK18U-jdk_aarch64_mac_hotspot_18.0.2.1_1.tar.gz"
		$JDK_SHA256 = "c5ec423f52d8f3aa632941f29fd289f2e31dce5fe6f3abed9b72bd374f54cd41"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2.1%2B1/OpenJDK18U-jdk_x64_windows_hotspot_18.0.2.1_1.zip"
		$JDK_SHA256 = "0846e98eaecc62aeba57bc1a522048fe3517177e36654f5d727abf8ce174c9b7"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.2.1%2B1/OpenJDK18U-jdk_x86-32_windows_hotspot_18.0.2.1_1.zip"
		$JDK_SHA256 = "2b3dfe42fe94946d2eced5da9354ae093de06c28797924e9597da37969cc5861"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/18.0.2/openjfx-18.0.2_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "7abb2bbdfdd7c9f90c9334f2a89a507fe30229bd9404c8cbf3e142fa113d3f45"
	}
	"Linux aarch64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/18.0.2/openjfx-18.0.2_linux-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "acf2c28ffd3a8ac1673a57948982635444eb0ff7d20d16d342dfbfc6a48cde66"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/18.0.2/openjfx-18.0.2_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "f6c60796e0cbd9fe59292b2d84bd6eb074943354cb9d48e0ac687a37c262e57d"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/18.0.2/openjfx-18.0.2_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "f8b768d873ebe81950442f6534cadcd7a77019bc31fa90fe1cd4131ca3d3aed4"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/18.0.2/openjfx-18.0.2_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "059df40ccee6fa3237eca134ad1979f6ea0387a134a813d6ccd7e15043f6496c"
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
