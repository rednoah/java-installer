# Java Installer for OpenJDK 13.0.2


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
		$JDK_URL = "https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "acc7a6aabced44e62ec3b83e3b5959df2b1aa6b3d610d58ee45f0c21a7821a71"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.2+9/bellsoft-jdk13.0.2+9-linux-i586.tar.gz"
		$JDK_SHA256 = "4c055d89255fa6e47f3f8b79fec375b5c49675fb84b7274d9b69a79a9511b868"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.2+9/bellsoft-jdk13.0.2+9-linux-aarch64.tar.gz"
		$JDK_SHA256 = "8b7d9a76af9439690a5465ba6d539133a53376e132714acd82b06234cf3de2b2"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.2+9/bellsoft-jdk13.0.2+9-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "971ea222c3eb67f38cc7c9dbfef67e31832e0f9191df65272c1722ca059a818f"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.2+9/bellsoft-jdk13.0.2+9-linux-ppc64le.tar.gz"
		$JDK_SHA256 = "ce5a13cee6904e8342cc6c7de34399e79193741edaadcb2ccd576d31aef970fe"
	}
	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "08fd2db3a3ab6fb82bb9091a035f9ffe8ae56c31725f4e17d573e48c39ca10dd"
	}
	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk13.0.2/d4173c853231432d94f001e99d882ca7/8/GPL/openjdk-13.0.2_windows-x64_bin.zip"
		$JDK_SHA256 = "fab29dcfda6ca4af3a9b973ecdde61dafcd9b307cb9237c25d25b2633bb08084"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.2+9/bellsoft-jdk13.0.2+9-windows-i586.zip"
		$JDK_SHA256 = "2eecb9fcddf4e3e91765346fd1f206fccb81e9a02021d5f90c62a0b2b29e3610"
	}

	"Windows x86_64 jre" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.2+9/bellsoft-jre13.0.2+9-windows-amd64.zip"
		$JDK_SHA256 = "118572f5b0ba823bfd053cf66888975adb72d7c23068e6567d575d1f3be1a43f"
	}
	"Darwin x86_64 jre" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.2+9/bellsoft-jre13.0.2+9-macos-amd64.zip"
		$JDK_SHA256 = "774b8abdb4f9037ce4bc6bf6ea5789badf378d0197b519d7d55ef971211a1f87"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/13.0.2/openjfx-13.0.2_linux-x64_bin-sdk.zip"
		$JDK_SHA256 = "0324bcb889030e06767686106699444921651879c4546d855791233b738cbf4f"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/13.0.2/openjfx-13.0.2_osx-x64_bin-sdk.zip"
		$JDK_SHA256 = "9e637520b65281f214a67b35c5028b70eedc288130ea78d142dd7fca44ae0ef4"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/13.0.2/openjfx-13.0.2_windows-x64_bin-sdk.zip"
		$JDK_SHA256 = "1d330675cd731c470f766c1e0b3f3878ba5d15706e23bcb4735c62fb62268500"
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
