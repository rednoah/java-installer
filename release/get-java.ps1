# Java Installer for OpenJDK 12


param (
	[string]$command = 'get',
	[string]$type = 'jdk',
	[string]$arch = 'x86_64'
)


$ErrorActionPreference = "Stop"


Switch ("$arch $type") {
	"x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_windows-x64_bin.zip"
		$JDK_SHA256 = "fc7d9eee3c09ea6548b00ca25dbf34a348b3942c815405a1428e0bfef268d08d"
	}
	"x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/12/openjfx-12_windows-x64_bin-sdk.zip"
		$JDK_SHA256 = "e5292de96363654320ce6ee6ae9b66cbab965713de85d948a06731a789ce910e"
	}
	"x86 jdk" {
		$JDK_URL = "https://github.com/bell-sw/Liberica/releases/download/12/bellsoft-jdk12-windows-i586-lite.zip"
		$JDK_SHA256 = "f13a3a7d803a74f568347f94d77eaf8ddf37d2fc8117d390d1529010a7f19154"
	}
	default {
		throw "CPU architecture not supported."
	}
}


# fetch JDK
$JDK_TAR_GZ = Split-Path -Leaf $JDK_URL

if (!(test-path $JDK_TAR_GZ)) {
	Write-Output "Download $JDK_TAR_GZ"
	Invoke-WebRequest -UseBasicParsing -Uri $JDK_URL -OutFile $JDK_TAR_GZ
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
