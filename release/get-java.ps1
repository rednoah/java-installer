# Java Installer for OpenJDK 16


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
		$JDK_URL = "https://download.java.net/java/GA/jdk16/7863447f0ab643c585b9bdebf67c69db/36/GPL/openjdk-16_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "e952958f16797ad7dc7cd8b724edd69ec7e0e0434537d80d6b5165193e33b931"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/16+36/bellsoft-jdk16+36-linux-i586.tar.gz"
		$JDK_SHA256 = "9aa017866e9736f36e3bf7efa8eadd2bb145e5b29b852e857570d294dfebb4e8"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/16+36/bellsoft-jdk16+36-linux-aarch64.tar.gz"
		$JDK_SHA256 = "8734bc9da726efc3c0d1cf2da871477c768ed531f5a237cc1b91eb75d13f5707"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/16+36/bellsoft-jdk16+36-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "0aceffdd204f5af2106d8e168fb66212882733f36bd26f6ee1da20b4d5c98658"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/16+36/bellsoft-jdk16+36-linux-ppc64le.tar.gz"
		$JDK_SHA256 = "807d52bf2cbcb4a5c12c176b97bc5a93b84f90aa97a368eeb1f1ba4243bbf874"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk16/7863447f0ab643c585b9bdebf67c69db/36/GPL/openjdk-16_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "16f3e39a31e86f3f51b0b4035a37494a47ed3c4ead760eafc6afd7afdf2ad9f2"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk16/7863447f0ab643c585b9bdebf67c69db/36/GPL/openjdk-16_windows-x64_bin.zip"
		$JDK_SHA256 = "a78bdeaad186297601edac6772d931224d7af6f682a43372e693c37020bd37d6"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/16+36/bellsoft-jdk16+36-windows-i586.zip"
		$JDK_SHA256 = "ee3aff0e1e9539263b7a59207f7914e3c4e03b2ac05261cfbf76cfa1275b25aa"
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
