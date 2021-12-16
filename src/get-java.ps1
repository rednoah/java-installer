# @{title} for @{jdk.name} @{jdk.version}


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
		$JDK_URL = "@{jdk.linux.x64.url}"
		$JDK_SHA256 = "@{jdk.linux.x64.sha256}"
	}
	"Linux i686 jdk" {
		$JDK_URL = "@{jdk.linux.x86.url}"
		$JDK_SHA256 = "@{jdk.linux.x86.sha256}"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "@{jdk.linux.aarch64.url}"
		$JDK_SHA256 = "@{jdk.linux.aarch64.sha256}"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "@{jdk.linux.arm.url}"
		$JDK_SHA256 = "@{jdk.linux.arm.sha256}"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "@{jdk.linux.ppc64le.url}"
		$JDK_SHA256 = "@{jdk.linux.ppc64le.sha256}"
	}

	"Darwin x86_64 jdk" {
		$JDK_URL = "@{jdk.mac.x64.url}"
		$JDK_SHA256 = "@{jdk.mac.x64.sha256}"
	}
	"Darwin arm64 jdk" {
		$JDK_URL = "@{jdk.mac.aarch64.url}"
		$JDK_SHA256 = "@{jdk.mac.aarch64.sha256}"
	}

	"Windows x86_64 jdk" {
		$JDK_URL = "@{jdk.windows.x64.url}"
		$JDK_SHA256 = "@{jdk.windows.x64.sha256}"
	}
	"Windows x86 jdk" {
		$JDK_URL = "@{jdk.windows.x32.url}"
		$JDK_SHA256 = "@{jdk.windows.x32.sha256}"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "@{jfx.linux.x64.url}"
		$JDK_SHA256 = "@{jfx.linux.x64.sha256}"
	}
	"Linux aarch64 jfx" {
		$JDK_URL = "@{jfx.linux.aarch64.url}"
		$JDK_SHA256 = "@{jfx.linux.aarch64.sha256}"
	}

	"Darwin x86_64 jfx" {
		$JDK_URL = "@{jfx.mac.x64.url}"
		$JDK_SHA256 = "@{jfx.mac.x64.sha256}"
	}
	"Darwin arm64 jfx" {
		$JDK_URL = "@{jfx.mac.aarch64.url}"
		$JDK_SHA256 = "@{jfx.mac.aarch64.sha256}"
	}

	"Windows x86_64 jfx" {
		$JDK_URL = "@{jfx.windows.x64.url}"
		$JDK_SHA256 = "@{jfx.windows.x64.sha256}"
	}

	default {
		throw "Architecture not supported: $os $arch $type"
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
