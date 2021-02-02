# Java Installer for OpenJDK 15.0.2


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
		$JDK_URL = "https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL/openjdk-15.0.2_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "91ac6fc353b6bf39d995572b700e37a20e119a87034eeb939a6f24356fbcd207"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-i586.tar.gz"
		$JDK_SHA256 = "62239fa62a31da34309458a492d6c8d0e88a21141dc78f7e1bbf1bdff5c00c23"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-aarch64.tar.gz"
		$JDK_SHA256 = "254a52b5bb3a6bf96c7b8fc7f278baa6e6f6bb61e0e4ae863b47897f6e1a6768"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "ac387e687763dbb72e9026e563f1bc3f0cb5f504536d9ab2bed1842b8ed05a16"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-ppc64le.tar.gz"
		$JDK_SHA256 = "4a23ad3a6d9ad523da6a4439483bae88995101672bef82fe1dc23acb5ea94b79"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL/openjdk-15.0.2_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "578b17748f5a7d111474bc4c9b5a8a06b4a4aa1ba4a4bc3fef014e079ece7c74"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL/openjdk-15.0.2_windows-x64_bin.zip"
		$JDK_SHA256 = "ecbe7f32bc6bff2b6c8e9b68f19cbf4ddf54a492c918ba471f32d645cf1c5cf4"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-windows-i586.zip"
		$JDK_SHA256 = "651eccdcc7a45d84e249f6cf1b6be2af1d210576f88f197d0dbf44de38de25de"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/15.0.1/openjfx-15.0.1_linux-x64_bin-jmods.zip"
		$JDK_SHA256 = "eb2472b26391805fe615c444f13df1dd48d1abd5501d847d50216a8519a0ac9c"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/15.0.1/openjfx-15.0.1_osx-x64_bin-jmods.zip"
		$JDK_SHA256 = "c66a77b21d6a5fdc4cfe114e5cbe11f4bc024c4471c7abd95b524eb77b1358e8"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/15.0.1/openjfx-15.0.1_windows-x64_bin-jmods.zip"
		$JDK_SHA256 = "3a0ef198d70de212e33b89b959ba007384ec339fe8537b66e2661c9147365f59"
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
