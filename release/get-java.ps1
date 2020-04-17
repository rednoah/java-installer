# Java Installer for OpenJDK 14.0.1


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
		$JDK_URL = "https://download.java.net/java/GA/jdk14.0.1/664493ef4a6946b186ff29eb326336a2/7/GPL/openjdk-14.0.1_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "22ce248e0bd69f23028625bede9d1b3080935b68d011eaaf9e241f84d6b9c4cc"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.1+8/bellsoft-jdk14.0.1+8-linux-i586.tar.gz"
		$JDK_SHA256 = "d1bcd4cf353843c6c141a6ed39a16fa0729338944db89e1e1e57edfbb54f89a0"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.1+8/bellsoft-jdk14.0.1+8-linux-aarch64.tar.gz"
		$JDK_SHA256 = "4075933836026cd97fcbb9707f26c479f04fe9309daf59a89d72c9d178d062e1"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.1+8/bellsoft-jdk14.0.1+8-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "ddac5faaab26d7b12583ee3702ded7a9e5e29d1a3ba6a5927e1772352c3a8f08"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.1+8/bellsoft-jdk14.0.1+8-linux-ppc64le.tar.gz"
		$JDK_SHA256 = "747a4f561c1f230eaa0f61249e4f659e73725f08e676ba9f57d6d3e517e84aeb"
	}
	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk14.0.1/664493ef4a6946b186ff29eb326336a2/7/GPL/openjdk-14.0.1_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "d8aa6806e6cc99724395563bf02fc6907a7c801f4caef85b96ad44927193da07"
	}
	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk14.0.1/664493ef4a6946b186ff29eb326336a2/7/GPL/openjdk-14.0.1_windows-x64_bin.zip"
		$JDK_SHA256 = "26255f3f2fe7168ec0dce9d9f3825649c18540ba86279a7506c7f17dd3e537f9"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.1+8/bellsoft-jdk14.0.1+8-windows-i586.zip"
		$JDK_SHA256 = "131124f2bdec7bed1b62a2b92d95014df2231213c9eb43271044538781395c43"
	}

	"Windows x86_64 jre" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.1+8/bellsoft-jre14.0.1+8-windows-amd64.zip"
		$JDK_SHA256 = "84503984467b20c6e261d18ac50d1a1e9930ba754b7eb3631c00cc848d9f3226"
	}
	"Darwin x86_64 jre" {
		$JDK_URL = "https://download.bell-sw.com/java/14.0.1+8/bellsoft-jre14.0.1+8-macos-amd64.zip"
		$JDK_SHA256 = "d633adfaed850cf7890ef0f150791b01395273bc45477afa2b1168b61d0fcf56"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/14.0.1/openjfx-14.0.1_linux-x64_bin-sdk.zip"
		$JDK_SHA256 = "87768e835334760a191ae7c0ae15471a4168118ac8a6bfd0732b16708d178424"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/14.0.1/openjfx-14.0.1_osx-x64_bin-sdk.zip"
		$JDK_SHA256 = "89b415660b4e4d18e955ce374728ae960476fc0436ea9412fa623783ac72a00c"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/14.0.1/openjfx-14.0.1_windows-x64_bin-sdk.zip"
		$JDK_SHA256 = "9f8a16b2f0b9bf4dd114b4c1ccb7801923a41689628d40b4fc4da1a0373c999a"
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
