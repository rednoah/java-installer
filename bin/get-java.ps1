# Java Installer for OpenJDK 17.0.2


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
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.2_8.tar.gz"
		$JDK_SHA256 = "288f34e3ba8a4838605636485d0365ce23e57d5f2f68997ac4c2e4c01967cd48"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/17.0.2+9/bellsoft-jdk17.0.2+9-linux-i586.tar.gz"
		$JDK_SHA256 = "7bc5857e9e5520074e93d38e71bb335ba99b700c74effeb4177d57c2c6d305b2"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.2_8.tar.gz"
		$JDK_SHA256 = "302caf29f73481b2b914ba2b89705036010c65eb9bc8d7712b27d6e9bedf6200"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_arm_linux_hotspot_17.0.2_8.tar.gz"
		$JDK_SHA256 = "544936145a4a9b1a316ed3708cd91b3960d5e8e87578bea73ef674ca3047158e"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_ppc64le_linux_hotspot_17.0.2_8.tar.gz"
		$JDK_SHA256 = "532d831d6a977e821b7331ecf9ed995e5bbfe76f18a1b00ffa8dbb3a4e2887de"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_x64_mac_hotspot_17.0.2_8.tar.gz"
		$JDK_SHA256 = "3630e21a571b7180876bf08f85d0aac0bdbb3267b2ae9bd242f4933b21f9be32"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.2_8.tar.gz"
		$JDK_SHA256 = "157518e999d712b541b883c6c167f8faabbef1d590da9fe7233541b4adb21ea4"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_x64_windows_hotspot_17.0.2_8.zip"
		$JDK_SHA256 = "d083479ca927dce2f586f779373d895e8bf668c632505740279390384edf03fa"
	}
	"Windows x86 jdk" {
		$JDK_URL = "@{jdk.windows.x32.url}"
		$JDK_SHA256 = "@{jdk.windows.x32.sha256}"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.2/openjfx-17.0.2_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "61310348a4017b295c19f1061f8ab52d66e16b65eadc6daffee40b68e0ea2b9e"
	}
	"Linux aarch64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.2/openjfx-17.0.2_linux-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "2ebd0a82bd55776d853a02c2503aeb5cd21a5f3ed1f33c703c9283975a3cc378"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.2/openjfx-17.0.2_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "b847f01ef1ce0b601348b57efa14701482b29df66bcf17ab3a38a5095bb759b6"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.2/openjfx-17.0.2_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "044a6aa0d8dead73565a3d0fcc6b3b4f63439a130acdc190d5a704a33b50ff0f"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/17.0.2/openjfx-17.0.2_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "46620068bbe216e4a31576e3339c676e6ed67976302748d8330f1068f65acea8"
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
