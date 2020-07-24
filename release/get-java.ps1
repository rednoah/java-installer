# Java Installer for OpenJDK 14.0.2


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
		$JDK_URL = "https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "91310200f072045dc6cef2c8c23e7e6387b37c46e9de49623ce0fa461a24623d"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-i586.tar.gz"
		$JDK_SHA256 = "f63478004ca7ddf9d5872bc24b4fd04ec9e904dfd963e45bbbbecd5bb93d410a"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-aarch64.tar.gz"
		$JDK_SHA256 = "2360eb766e60909b0ac26d4a6debc291b040ec09160b5e27b75d0500778252ce"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "78006d57b8793cccc112c12db6b7db53c9ab2d441285a6fad2da331258eee615"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-ppc64le.tar.gz"
		$JDK_SHA256 = "ca50c4dc595133a2dae2360d3e10d663f9e94597319594726aaa0df9d5c36372"
	}
	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "386a96eeef63bf94b450809d69ceaa1c9e32a97230e0a120c1b41786b743ae84"
	}
	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_windows-x64_bin.zip"
		$JDK_SHA256 = "20600c0bda9d1db9d20dbe1ab656a5f9175ffb990ef3df6af5d994673e4d8ff9"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-windows-i586.zip"
		$JDK_SHA256 = "aa5cb80259f163577f17bcfa1ff6d2eee8aab9081c952eeef18ba4c51871f99b"
	}

	"Windows x86_64 jre" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.2+13/bellsoft-jre14.0.2+13-windows-amd64.zip"
		$JDK_SHA256 = "b34af586813958299c2b0386c74a0404dac6712e7b7168e1b7aeec394cfd7010"
	}
	"Darwin x86_64 jre" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.2+13/bellsoft-jre14.0.2+13-macos-amd64.zip"
		$JDK_SHA256 = "a2853bfd9bd6ec23c29bfcfb1b1aec30ad6d73c6ba954a13ec26b70a33e24d82"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/14.0.2.1/openjfx-14.0.2.1_linux-x64_bin-sdk.zip"
		$JDK_SHA256 = "21761bfb966120d8c8b697ab3d87c26183fb444e7200936711eff31a8db2e9b7"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/14.0.2.1/openjfx-14.0.2.1_osx-x64_bin-sdk.zip"
		$JDK_SHA256 = "228973dd66beb80f2734b44868b57adbac793427e26672cad641631683ea685c"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/14.0.2.1/openjfx-14.0.2.1_windows-x64_bin-sdk.zip"
		$JDK_SHA256 = "6679bbb0eafbeb61d513026ffa7d888e6737598acbc1778d81b2d839c99c4245"
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
