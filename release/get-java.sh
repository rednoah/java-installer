#!/bin/sh

# Java Installer for OpenJDK 21.0.9

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_x64_linux_hotspot_21.0.9_10.tar.gz"
		JDK_SHA256="810d3773df7e0d6c4394e4e244b264c8b30e0b05a0acf542d065fd78a6b65c2f"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.9_10.tar.gz"
		JDK_SHA256="edf0da4debe7cf475dbe320d174d6eed81479eb363f41e38a2efb740428c603a"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.9_10.tar.gz"
		JDK_SHA256="ac5a0394a234269b4e20459649ac93cb702cde29b3e46a0bcf3aa53958f2d4a4"
	;;
	"Linux riscv64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_riscv64_linux_hotspot_21.0.9_10.tar.gz"
		JDK_SHA256="ac411d52862fe8a4a48a6c3546bebced8f4879cd728746fc4ee4b06151aa9f8b"
	;;
	"Darwin x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_x64_mac_hotspot_21.0.9_10.tar.gz"
		JDK_SHA256="f803a3f5bce141f23ac699dfcda06a721f4b74f53bacb0f4bbe9bfcad54427d8"
	;;
	"Darwin arm64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.9_10.tar.gz"
		JDK_SHA256="55a40abeb0e174fdc70f769b34b50b70c3967e0b12a643e6a3e23f9a582aac16"
	;;
	"Windows x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_x64_windows_hotspot_21.0.9_10.zip"
		JDK_SHA256="1c67df516e9795c0b09f5714bfe151da2e3cc988082042f5bbb60d75e4e63fb5"
	;;
	"Windows aarch64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.9%2B10/OpenJDK21U-jdk_aarch64_windows_hotspot_21.0.9_10.zip"
		JDK_SHA256="260a71ee94cdefba0937fad3f88ae017d5d37a9474ae91798bc8dffb8f308a83"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.9/openjfx-21.0.9_linux-x64_bin-jmods.zip"
		JDK_SHA256="44d718a6118815aadfa2510454e8fd9cd71af4796499477820272daa970dbfd5"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.9/openjfx-21.0.9_osx-x64_bin-jmods.zip"
		JDK_SHA256="a1d4cea780dbe8a51b48a5bf4caa4b5f6cfd40b40db61ac25005c9db44d30af4"
	;;
	"Darwin arm64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.9/openjfx-21.0.9_osx-aarch64_bin-jmods.zip"
		JDK_SHA256="f64d4e65f51f7d6b302608fb04814d981c07d369fe55e99d14e0b16941f6399b"
	;;
	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.9/openjfx-21.0.9_windows-x64_bin-jmods.zip"
		JDK_SHA256="ece676af80d7408e0a130dd77495acb61c70434ea42bd29380df32bcf9d8354b"
	;;

	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.9+11/bellsoft-jdk21.0.9+11-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="ae2d3e750496da6d5fd467c5c7e0d2146bdcdd8ad9aa902a09fbdfc3cb542e86"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.9+11/bellsoft-jdk21.0.9+11-linux-i586.tar.gz"
		JDK_SHA256="8f1f883a4dcc9076367a89f290eb69a0249943bd540ce046982846aa54bea51c"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.9+11/bellsoft-jdk21.0.9+11-windows-i586.zip"
		JDK_SHA256="3d1d25c234fb53dcca94fc9a13f821e0b314232e7d854e174e3770879cf25908"
	;;

	*)
		echo "Architecture not supported: $OS $ARCH $TYPE"
		exit 1
	;;
esac


# fetch JDK
JDK_TAR_GZ=${5:-`basename $JDK_URL`}

if [ ! -f "$JDK_TAR_GZ" ]; then
	echo "Download $JDK_URL"
	curl --output "$JDK_TAR_GZ" --insecure --location --retry 5 "$JDK_URL"
fi


# verify archive via SHA-256 checksum
JDK_SHA256_ACTUAL=`openssl dgst -sha256 -hex "$JDK_TAR_GZ" | awk '{print $NF}'`
echo "Expected SHA256 checksum: $JDK_SHA256"
echo "Actual SHA256 checksum: $JDK_SHA256_ACTUAL"

if [ "$JDK_SHA256" != "$JDK_SHA256_ACTUAL" ]; then
	echo "ERROR: SHA256 checksum mismatch"
	rm -vf "$JDK_TAR_GZ"
	exit 1
fi


# extract and link only if explicitly requested
if [ "$COMMAND" != "install" ]; then
	echo "Download complete: $JDK_TAR_GZ"
	exit 0
fi


echo "Extract $JDK_TAR_GZ"
tar -v -zxf "$JDK_TAR_GZ"

# find java executable
JAVA_EXE=`find "$PWD" -name "java" -type f | head -n 1`

# link executable into /usr/local/bin/java
mkdir -p "/usr/local/bin"
ln -s -f "$JAVA_EXE" "/usr/local/bin/java"

# link java home to /usr/local/java
JAVA_BIN=`dirname $JAVA_EXE`
JAVA_HOME=`dirname $JAVA_BIN`
ln -s -f "$JAVA_HOME" "/usr/local/java"

# test
echo "Execute $JAVA_EXE -XshowSettings -version"
"$JAVA_EXE" -XshowSettings -version
