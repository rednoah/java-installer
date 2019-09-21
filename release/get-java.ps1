# Java Installer for OpenJDK 13


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
		$JDK_URL = "https://download.java.net/java/GA/jdk13/5b8a42f3905b406298b72d750b6919f6/33/GPL/openjdk-13_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "5f547b8f0ffa7da517223f6f929a5055d749776b1878ccedbd6cc1334f4d6f4d"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13/bellsoft-jdk13-linux-i586.tar.gz"
		$JDK_SHA256 = "5f2fbbf6dd6b3467ad4a6d7f246e2bc4bb33b0be7d242a1b64c6e10b81fa73c3"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13/bellsoft-jdk13-linux-aarch64.tar.gz"
		$JDK_SHA256 = "726f7935fba33f8cac6f819366069f4ad77f695d0d49cc280fe13318c8d36f96"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13/bellsoft-jdk13-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "c3e70fde65666b7fa52718bb8c2bca98ebb24356f594a73b1d64ee53cb222d8f"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13/bellsoft-jdk13-linux-ppc64le.tar.gz"
		$JDK_SHA256 = "57d4164bfc17b61e07018671e068daf611eb13ecf713a8ce0fa2dfcaa69f4f8a"
	}
	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk13/5b8a42f3905b406298b72d750b6919f6/33/GPL/openjdk-13_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "1a9c096630a0e4f27ce61ac9e477378b8581c537568186d4afd0b416a7e9dd68"
	}
	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk13/5b8a42f3905b406298b72d750b6919f6/33/GPL/openjdk-13_windows-x64_bin.zip"
		$JDK_SHA256 = "053d8c87bb34347478512911a6218a389720bffcde4e496be5a54d51ad7c9c2f"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13/bellsoft-jdk13-windows-i586.zip"
		$JDK_SHA256 = "51afe9d902df2dea5bcc7b05a6e669f9e1660d5a39eee84abc33b88ad17631d4"
	}

	"Windows x86_64 jre" {
		$JDK_URL = "https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13+33/OpenJDK13U-jre_x64_windows_hotspot_13_33.zip"
		$JDK_SHA256 = "cdcc461336ea110c376722d7e4050076387d584e1c1309d3b6b1903f5f447b16"
	}
	"Darwin x86_64 jre" {
		$JDK_URL = "https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13+33/OpenJDK13U-jre_x64_mac_hotspot_13_33.tar.gz"
		$JDK_SHA256 = "1c23efba7908de9a611a98e755602f45381a8f7c957adb3fc4012ab1369a352c"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/13/openjfx-13_linux-x64_bin-sdk.zip"
		$JDK_SHA256 = "6f2d1ed4678615d909546b2b4a88f710fd7367bb78a0d7c195ee4645a4c7efc5"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/13/openjfx-13_osx-x64_bin-sdk.zip"
		$JDK_SHA256 = "d969b2fb0bb628dcf17ffc1df1ab3839f6da09569407b4375cc301ac0f290a47"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/13/openjfx-13_windows-x64_bin-sdk.zip"
		$JDK_SHA256 = "1880be36b2873cec3dbda206094aff78517cd958cd70c9054c19d928d5a6a250"
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
