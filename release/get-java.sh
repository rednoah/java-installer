#!/bin/sh

# Java Installer for OpenJDK 21.0.13

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_x64_linux_hotspot_21.0.13.1_2.tar.gz"
		JDK_SHA256="bb8a93f9ae6e7a693b2b721e85dbeff26ae1a77447985a8d7afcdd9c7cf6222e"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.13.1_2.tar.gz"
		JDK_SHA256="8c72816a6b308842d5ed1f13e5826b69c567da4784f7238d7e800efa71fe54b1"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.13.1_2.tar.gz"
		JDK_SHA256="4d3d75690785cf593002446005427bb3c61de163f2469343572cdcb0d258ed62"
	;;
	"Linux riscv64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_riscv64_linux_hotspot_21.0.13.1_2.tar.gz"
		JDK_SHA256="24b41c3ece0ec72b07f95e04f2a150f7b0c645040843d3c32299cdd1e19fcb2d"
	;;
	"Darwin x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.3%2B9/OpenJDK21U-jdk_x64_mac_hotspot_21.0.3_9.tar.gz"
		JDK_SHA256="f777103aab94330d14a29bd99f3a26d60abbab8e2c375cec9602746096721a7c"
	;;
	"Darwin arm64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.13.1_2.tar.gz"
		JDK_SHA256="48067f2b7c958ed104a9d8a5749be7d25220b0a356b4d2d1bcfaab3e16ad0b14"
	;;
	"Windows x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13.1%2B2/OpenJDK21U-jdk_x64_windows_hotspot_21.0.13.1_2.zip"
		JDK_SHA256="bbebea1469996b276683c9299c227b294f85c847039c82633218186a4ad4fbf2"
	;;
	"Windows aarch64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.12.1%2B1/OpenJDK21U-jdk_aarch64_windows_hotspot_21.0.12.1_1.zip"
		JDK_SHA256="ccf2e51f527d542a70ba5794a600d3aac04b4e967950e227834c7566cb1bec7b"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.13.1/openjfx-21.0.13.1_linux-x64_bin-jmods.zip"
		JDK_SHA256="b9d535d1e9598dd1f3ef512d5048bdf5ee4a83da687f8bcbc06e37bc900d3f6e"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.3/openjfx-21.0.3_osx-x64_bin-jmods.zip"
		JDK_SHA256="0a12ad01d8450437be3608175428b336f94bc8446123e804ae99d2d09a158a76"
	;;
	"Darwin arm64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.13.1/openjfx-21.0.13.1_osx-aarch64_bin-jmods.zip"
		JDK_SHA256="eb0a452f83708b40248a6fe382274d7953f51d7d185e72c27a726dd2140a6b75"
	;;
	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.13.1/openjfx-21.0.13.1_windows-x64_bin-jmods.zip"
		JDK_SHA256="9d140905e3cd13832d6c85d7eb1029c17810d3be49f9603e0070e9b03e7f0918"
	;;

	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.13.1+5/bellsoft-jdk21.0.13.1+5-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="24147b527617905d47248f2667dba4148ed4a9ddf8bf00963d83bb7743739911"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.13.1+5/bellsoft-jdk21.0.13.1+5-linux-i586.tar.gz"
		JDK_SHA256="abc8d5a8c317d79a6bc922d8acc07585ba1b7c46ed3d4358d50c3f1fb57d0957"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.13.1+5/bellsoft-jdk21.0.13.1+5-windows-i586.zip"
		JDK_SHA256="32e63461f95eefbefd8ebebcc84bb89b50209217280a732bbfbbc2046f9d5986"
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
