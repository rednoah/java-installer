# Java Installer for OpenJDK 21.0.7


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
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.7%2B6/OpenJDK21U-jdk_x64_linux_hotspot_21.0.7_6.tar.gz"
		$JDK_SHA256 = "974d3acef0b7193f541acb61b76e81670890551366625d4f6ca01b91ac152ce0"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.7+9/bellsoft-jdk21.0.7+9-linux-i586.tar.gz"
		$JDK_SHA256 = "eee93adb14c9ae484797ff0c3f5655b8766a36ac228cbe717b518b94bc6efaf4"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.7%2B6/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.7_6.tar.gz"
		$JDK_SHA256 = "31dba70ba928c78c20d62049ac000f79f7a7ab11f9d9c11e703f52d60aa64f93"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.7+9/bellsoft-jdk21.0.7+9-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "876266881a8d1a1d2c86e1207e969311a0ebfe15f2d7ca19da1bcd052c798d4f"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.7%2B6/OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.7_6.tar.gz"
		$JDK_SHA256 = "2ddc0dc14b07d9e853875aac7f84c23826fff18b9cea618c93efe0bcc8f419c2"
	}
	"Linux riscv64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.7%2B6/OpenJDK21U-jdk_riscv64_linux_hotspot_21.0.7_6.tar.gz"
		$JDK_SHA256 = "d75f33ee7f9e5532bce263db83443ffed7d9bae7ff3ed41e48d137808adfe513"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.7%2B6/OpenJDK21U-jdk_x64_mac_hotspot_21.0.7_6.tar.gz"
		$JDK_SHA256 = "8e6d876f60bc8b7866e91222ba9f27a78e5102d7a4ce4a6e915f95fe539b66ed"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.7%2B6/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.7_6.tar.gz"
		$JDK_SHA256 = "6fcb25f3f71a5ff245dec4ebe8bd5c643f179a5cd0a61c08e58a8c65914d2f97"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.7%2B6/OpenJDK21U-jdk_x64_windows_hotspot_21.0.7_6.zip"
		$JDK_SHA256 = "38f4b9fa0b36def9812f6576fd45f6224630477db8c4e669ee78eaa35abb9195"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.7+9/bellsoft-jdk21.0.7+9-windows-i586.zip"
		$JDK_SHA256 = "4fcb1cf8b85bd8e79905a0bf1ca5ed12584e41e75b1e3d84a9d3851f368e0634"
	}
	"Windows aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/21.0.7+9/bellsoft-jdk21.0.7+9-windows-aarch64.zip"
		$JDK_SHA256 = "8e33b4bd31e73e9e70981046bb22c2b5062cad8a4ff922a0afa3015b20a2615f"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.7/openjfx-21.0.7_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "2a3dc0f2aab9a9062c2fd1bc3a31228abdaaba585a7d7b763c31fb78af416d96"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.7/openjfx-21.0.7_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "940532bcc5294625ee918cd6efe72c1c93f4c8969cf044687dac68e7d59ec067"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.7/openjfx-21.0.7_osx-aarch64_bin-jmods.zip"
		$JDK_SHA256 = "53c465b2a3af83248a3aec26a1485b06d80bfe2adbe015b65f9d724760483367"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/21.0.7/openjfx-21.0.7_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "bd681e8bf320b604749d0919ece34116053c34b2e3969adac648028b32af519a"
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
