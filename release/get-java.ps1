# Java Installer for OpenJDK 15.0.1


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
		$JDK_URL = "https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "83ec3a7b1649a6b31e021cde1e58ab447b07fb8173489f27f427e731c89ed84a"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15.0.1+9/bellsoft-jdk15.0.1+9-linux-i586.tar.gz"
		$JDK_SHA256 = "287a4c2e62f00faa270cbdcb4e578dc71040593316f13125eec24b1b4ac0a99e"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15.0.1+9/bellsoft-jdk15.0.1+9-linux-aarch64.tar.gz"
		$JDK_SHA256 = "eeab09fb1b09fbf1e2ee8859d506c0e7ea9b780d0d015504b4a1e108f066ab45"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15.0.1+9/bellsoft-jdk15.0.1+9-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "9dbd04943165d34fdfa5676c2eefe13b8a2772c6c91c2635dd472189ccc2def7"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15.0.1+9/bellsoft-jdk15.0.1+9-linux-ppc64le.tar.gz"
		$JDK_SHA256 = "312b116e85c1a7f53b260da1791936428199212666f5fbb6f6227c8936a5510d"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "e1d4868fb082d9202261c5a05251eded56fb805da2d641a65f604988b00b1979"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk15.0.1/51f4f36ad4ef43e39d0dfdbaf6549e32/9/GPL/openjdk-15.0.1_windows-x64_bin.zip"
		$JDK_SHA256 = "0a27c733fc7ceaaae3856a9c03f5e2304af30a32de6b454b8762ec02447c5464"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/15.0.1+9/bellsoft-jdk15.0.1+9-windows-i586.zip"
		$JDK_SHA256 = "552aaca2691b17369061667a93063d6778b23379dc6c83a5f8556b99be80db35"
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
