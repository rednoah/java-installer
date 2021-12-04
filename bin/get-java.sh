#!/bin/sh

# Java Installer for OpenJDK 17.0.1

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_linux_hotspot_17.0.1_12.tar.gz"
		JDK_SHA256="6ea18c276dcbb8522feeebcfc3a4b5cb7c7e7368ba8590d3326c6c3efc5448b6"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/17.0.1+12/bellsoft-jdk17.0.1+12-linux-i586.tar.gz"
		JDK_SHA256="7dda1aac55e66e962d32c1a4661360b05c891645197f785f2052fafc9a0d350b"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.1_12.tar.gz"
		JDK_SHA256="f23d482b2b4ada08166201d1a0e299e3e371fdca5cd7288dcbd81ae82f3a75e3"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_arm_linux_hotspot_17.0.1_12.tar.gz"
		JDK_SHA256="f5945a39929384235e7cb1c57df071b8c7e49274632e2a54e54b2bad05de21a5"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_ppc64le_linux_hotspot_17.0.1_12.tar.gz"
		JDK_SHA256="bd65d4e8ecc4236924ae34d2075b956799abca594021e1b40c36aa08a0d610b0"
	;;

	"Darwin x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_mac_hotspot_17.0.1_12.tar.gz"
		JDK_SHA256="98a759944a256dbdd4d1113459c7638501f4599a73d06549ac309e1982e2fa70"
	;;
	"Darwin arm64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.1_12.tar.gz"
		JDK_SHA256="02073590da24421e119ddebe6b061bf132fa68694c60706f092d32d963822554"
	;;

	"Windows x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x64_windows_hotspot_17.0.1_12.zip"
		JDK_SHA256="e5419773052ac6479ff211d5945f8625e0cdb036e69c0f71affaf02d5dc9aa0b"
	;;
	"Windows x86 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.1%2B12/OpenJDK17U-jdk_x86-32_windows_hotspot_17.0.1_12.zip"
		JDK_SHA256="604919b02caa5506e8c68888d6410384234e9a9fb0dbc6a0d97eb7652da4cf66"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_linux-x64_bin-jmods.zip"
		JDK_SHA256="28662b6fcdaedaaf23ee6dbef2d632bf2a53e30aaa9231f27e00e6ceb10238a0"
	;;
	"Linux aarch64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_linux-aarch64_bin-jmods.zip"
		JDK_SHA256="40525cc333f48acbc62657f5cfbc30635940c4bc61d42f6a1e19ab3e208b2744"
	;;

	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_osx-x64_bin-jmods.zip"
		JDK_SHA256="836f8c88235d2f38b0922b4b2949e35071e9e0a7c1d22a0bebc67b476885b56b"
	;;
	"Darwin arm64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_osx-aarch64_bin-jmods.zip"
		JDK_SHA256="90c922bdf87686b81deadbffd5c75186f92851852df333b870bf61e98e04c190"
	;;

	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/17.0.1/openjfx-17.0.1_windows-x64_bin-jmods.zip"
		JDK_SHA256="a9b8dbd6b67081470d7b4204af2b7ffb6130c07daf1e2967eec7c9342f6d2caf"
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
	curl -fsSL -o "$JDK_TAR_GZ" --retry 5 "$JDK_URL"
fi


# verify archive via SHA-256 checksum
JDK_SHA256_ACTUAL=`openssl dgst -sha256 -hex "$JDK_TAR_GZ" | awk '{print $NF}'`
echo "Expected SHA256 checksum: $JDK_SHA256"
echo "Actual SHA256 checksum: $JDK_SHA256_ACTUAL"

if [ "$JDK_SHA256" != "$JDK_SHA256_ACTUAL" ]; then
	echo "ERROR: SHA256 checksum mismatch"
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
