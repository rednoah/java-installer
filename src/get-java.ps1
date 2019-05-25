# @{title} for @{jdk.name} @{jdk.version}


param (
	[string]$command = 'get',
	[string]$type = 'jdk',
	[string]$arch = 'x86_64'
)


$ErrorActionPreference = "Stop"


Switch ("$arch $type") {
	"x86_64 jdk" {
		$JDK_URL = "@{jdk.windows.x64.url}"
		$JDK_SHA256 = "@{jdk.windows.x64.sha256}"
	}
	"x86_64 jre" {
		$JDK_URL = "@{jre.windows.x64.url}"
		$JDK_SHA256 = "@{jre.windows.x64.sha256}"
	}
	"x86_64 jfx" {
		$JDK_URL = "@{jfx.windows.x64.url}"
		$JDK_SHA256 = "@{jfx.windows.x64.sha256}"
	}
	"x86 jdk" {
		$JDK_URL = "@{jdk.windows.x86.url}"
		$JDK_SHA256 = "@{jdk.windows.x86.sha256}"
	}
	default {
		throw "CPU architecture not supported."
	}
}


# fetch JDK
$JDK_TAR_GZ = "@{jdk.name}_@{jdk.version}_$arch-$jdk.zip"

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
