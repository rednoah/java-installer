# Java Installer for OpenJDK 16.0.1


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
		$JDK_URL = "https://download.java.net/java/GA/jdk16.0.1/7147401fd7354114ac51ef3e1328291f/9/GPL/openjdk-16.0.1_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "b1198ffffb7d26a3fdedc0fa599f60a0d12aa60da1714b56c1defbce95d8b235"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/16.0.1+9/bellsoft-jdk16.0.1+9-linux-i586.tar.gz"
		$JDK_SHA256 = "a33a9b92380759e0e9efc6f3f08cf403cd9dfa4b3fbdefe77bbee67b431b3370"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/16.0.1+9/bellsoft-jdk16.0.1+9-linux-aarch64.tar.gz"
		$JDK_SHA256 = "650f04865bdd3267ab7d1ae459dc34a430b6b6c2c6f04c479f01c728717bda48"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/16.0.1+9/bellsoft-jdk16.0.1+9-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "3b701e52122419e6dd66e1086a2cba7613d63e6fd9073afcce1dfe7e9f1404b7"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/16.0.1+9/bellsoft-jdk16.0.1+9-linux-ppc64le.tar.gz"
		$JDK_SHA256 = "197b45dd685212307fa8affa9bdba0549b826dcafd770e4b20c2feaffd4b787b"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk16.0.1/7147401fd7354114ac51ef3e1328291f/9/GPL/openjdk-16.0.1_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "6098f839954439d4916444757c542c1b8778a32461706812d41cc8bbefce7f2f"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk16.0.1/7147401fd7354114ac51ef3e1328291f/9/GPL/openjdk-16.0.1_windows-x64_bin.zip"
		$JDK_SHA256 = "733b45b09463c97133d70c2368f1b9505da58e88f2c8a84358dd4accfd06a7a4"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/16.0.1+9/bellsoft-jdk16.0.1+9-windows-i586.zip"
		$JDK_SHA256 = "429c96779a94a7e9e266acc304c77e79c5524f4d7c1410c62869e1720459e7c7"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/16/openjfx-16_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "6d9d974119efafc9d3634c588dc4c94315db76d41693d09470b43922557bcfb4"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/16/openjfx-16_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "054f850ed72a959f524ffa2adbbf7aa13292d85f1e09f414a754e6d40e43ecbc"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/16/openjfx-16_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "29b5b3086a03e4d991be761be887d6a878cdc5edeab896d9f2e0587a97f7f03f"
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
