# Java Installer for OpenJDK 12.0.2


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
		$JDK_URL = "https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "75998a6ebf477467aa5fb68227a67733f0e77e01f737d4dfbc01e617e59106ed"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/12.0.2/bellsoft-jdk12.0.2-linux-i586.tar.gz"
		$JDK_SHA256 = "d43ef56157562d976a4d5879ee48135907705b0752d51f7209920bb065b4fb57"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/12.0.2/bellsoft-jdk12.0.2-linux-aarch64.tar.gz"
		$JDK_SHA256 = "57efb2646ca7337b1ec0dacfcaf04c54c451a5948deb856f994bbb2a02291059"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/12.0.2/bellsoft-jdk12.0.2-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "f5173ae74dbfc9e968a077e73095445c0262974f46b1de7f4275432d32b67403"
	}
	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "675a739ab89b28a8db89510f87cb2ec3206ec6662fb4b4996264c16c72cdd2a1"
	}
	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_windows-x64_bin.zip"
		$JDK_SHA256 = "a30bed3d6d62f6ae1052aaf3c6956aaee8e3deb2f50f155575112f3f29411fba"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/12.0.2/bellsoft-jdk12.0.2-windows-i586.zip"
		$JDK_SHA256 = "b986b884bccd73e548cc36b2367910e1e1f2fc144bcfd9775b16ceb098627ff6"
	}

	"Windows x86_64 jre" {
		$JDK_URL = "https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.2+10/OpenJDK12U-jre_x64_windows_hotspot_12.0.2_10.zip"
		$JDK_SHA256 = "c03fdbced77d74557d2ede7a120b09e2573dde7527a4c019458b6f20920aa632"
	}
	"Darwin x86_64 jre" {
		$JDK_URL = "https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.2+10/OpenJDK12U-jre_x64_mac_hotspot_12.0.2_10.tar.gz"
		$JDK_SHA256 = "825929ef188019f6b8da461d1279b1b0d26cdca16760dc7b2565b6fc627d29a5"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/12.0.2/openjfx-12.0.2_linux-x64_bin-sdk.zip"
		$JDK_SHA256 = "7f91f7bfafd265672e16e34242361048f82f8959d493d9ed43339ede26c060ac"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/12.0.2/openjfx-12.0.2_osx-x64_bin-sdk.zip"
		$JDK_SHA256 = "a87b0a6f30bcf21ec1bd1c89e1596f43dc5b0d7fd302776d0d0d2e226022fead"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/12.0.2/openjfx-12.0.2_windows-x64_bin-sdk.zip"
		$JDK_SHA256 = "5b29930518b3e8eb01c206222fd5347c45b236fdd933db4540a7362488831bd9"
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
