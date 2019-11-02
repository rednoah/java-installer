# Java Installer for OpenJDK 13.0.1


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
		$JDK_URL = "https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_linux-x64_bin.tar.gz"
		$JDK_SHA256 = "2e01716546395694d3fad54c9b36d1cd46c5894c06f72d156772efbcf4b41335"
	}
	"Linux i686 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.1/bellsoft-jdk13.0.1-linux-i586.tar.gz"
		$JDK_SHA256 = "c22da22bbf68b5df958ca20b168d3857539f61c2d0b9161487d5ca1517f5bd88"
	}
	"Linux aarch64 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.1/bellsoft-jdk13.0.1-linux-aarch64.tar.gz"
		$JDK_SHA256 = "8043992c89cd4e9e9fbe5a03567a30ec6e7424b87d69f2322e6f31a2f40b1299"
	}
	"Linux armv7l jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.1/bellsoft-jdk13.0.1-linux-arm32-vfp-hflt.tar.gz"
		$JDK_SHA256 = "e3764deca0f72bab9737c16b4a3655040ab4c51ecfad837179c4b8e232d64381"
	}
	"Linux ppc64le jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.1/bellsoft-jdk13.0.1-linux-ppc64le.tar.gz"
		$JDK_SHA256 = "8adad397ed1f85f9bae3625688b6780bb90eaaa96c8d0ba2d79673aa9e85318b"
	}
	"Darwin x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_osx-x64_bin.tar.gz"
		$JDK_SHA256 = "593c5c9dc0978db21b06d6219dc8584b76a59c79d57e6ec1b28ad0d848a7713f"
	}
	"Windows x86_64 jdk" {
		$JDK_URL = "https://download.java.net/java/GA/jdk13.0.1/cec27d702aa74d5a8630c65ae61e4305/9/GPL/openjdk-13.0.1_windows-x64_bin.zip"
		$JDK_SHA256 = "438a6920f1851b1eeb6f09f05d9f91c4423c6586f7a1a7ccbb19df76ea5901ee"
	}
	"Windows x86 jdk" {
		$JDK_URL = "https://download.bell-sw.com/java/13.0.1/bellsoft-jdk13.0.1-windows-i586.zip"
		$JDK_SHA256 = "19961e0a0110b6ca858245f8b5d5b55d560d168c4c39477aa0bfc2f55e48464d"
	}

	"Windows x86_64 jre" {
		$JDK_URL = "https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13.0.1+9/OpenJDK13U-jre_x64_windows_hotspot_13.0.1_9.zip"
		$JDK_SHA256 = "fd3fc1085f29bab990b31bd96c38cfca439de317e97340351e88f7c77a7e070b"
	}
	"Darwin x86_64 jre" {
		$JDK_URL = "https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13.0.1+9/OpenJDK13U-jre_x64_mac_hotspot_13.0.1_9.tar.gz"
		$JDK_SHA256 = "5e60a1364a363f74b0210d6c3fc3cefec98dcada75c8b239031e3947833e334a"
	}

	"Linux x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/13.0.1/openjfx-13.0.1_linux-x64_bin-sdk.zip"
		$JDK_SHA256 = "942dd3a649668c4df5ac791139cea96ea52998403c8d066f7bb64f6d77485a5c"
	}
	"Darwin x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/13.0.1/openjfx-13.0.1_osx-x64_bin-sdk.zip"
		$JDK_SHA256 = "c7c4580b2f8d4a516f786bc1f75881273d4b7a67fb59a33c74172ec95980d278"
	}
	"Windows x86_64 jfx" {
		$JDK_URL = "https://download2.gluonhq.com/openjfx/13.0.1/openjfx-13.0.1_windows-x64_bin-sdk.zip"
		$JDK_SHA256 = "5e2ad52dff5c5e9aa33b5ffdb4b6b71bd8b28f14a1e529828e1b587a6abf7ae5"
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
