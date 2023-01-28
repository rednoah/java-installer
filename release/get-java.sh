#!/bin/sh

# Java Installer for OpenJDK 17.0.6

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.6%2B10/OpenJDK17U-jdk_x64_linux_hotspot_17.0.6_10.tar.gz"
		JDK_SHA256="a0b1b9dd809d51a438f5fa08918f9aca7b2135721097f0858cf29f77a35d4289"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/17.0.6+10/bellsoft-jdk17.0.6+10-linux-i586.tar.gz"
		JDK_SHA256="60602edba7731e4f1db82468a72c26d0bbeff2ade3ebe184416bd550496d1356"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.6%2B10/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.6_10.tar.gz"
		JDK_SHA256="9e0e88bbd9fa662567d0c1e22d469268c68ac078e9e5fe5a7244f56fec71f55f"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.6%2B10/OpenJDK17U-jdk_arm_linux_hotspot_17.0.6_10.tar.gz"
		JDK_SHA256="fe4d0c6d5bb8cf7f59f7ff82c0c1fd988bbe5cccf3bc7377dc8ae50740b46c82"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.6%2B10/OpenJDK17U-jdk_ppc64le_linux_hotspot_17.0.6_10.tar.gz"
		JDK_SHA256="cb772c3fdf3f9fed56f23a37472acf2b80de20a7113fe09933891c6ef0ecde95"
	;;

	"Darwin x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.6%2B10/OpenJDK17U-jdk_x64_mac_hotspot_17.0.6_10.tar.gz"
		JDK_SHA256="faa2927584cf2bd0a35d2ac727b9f22725e23b2b24abfb3b2ac7140f4d65fbb4"
	;;
	"Darwin arm64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.6%2B10/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.6_10.tar.gz"
		JDK_SHA256="e4904557f6e02f62b830644dc257c0910525f03df77bcffaaf92fa02a057230c"
	;;

	"Windows x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.6%2B10/OpenJDK17U-jdk_x64_windows_hotspot_17.0.6_10.zip"
		JDK_SHA256="d544c4f00d414a1484c0a5c1758544f30f308c4df33f9a28bd4a404215d0d444"
	;;
	"Windows x86 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.6%2B10/OpenJDK17U-jdk_x86-32_windows_hotspot_17.0.6_10.zip"
		JDK_SHA256="34d7845a5d463836eaf16f646d15941dcacc8869c697d176ac2e4efae2a73f2f"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/19.0.2.1/openjfx-19.0.2.1_linux-x64_bin-jmods.zip"
		JDK_SHA256="252325b8265fe6c658d6532f6a3f7c0cd49102a67e376f76ab4afc22f1b3535f"
	;;
	"Linux aarch64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/19.0.2.1/openjfx-19.0.2.1_linux-aarch64_bin-jmods.zip"
		JDK_SHA256="b50d460f3d4acfbc97138fa1416ac981c4773f5732cdd005ddc083010b5a8f03"
	;;

	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/19.0.2.1/openjfx-19.0.2.1_osx-x64_bin-jmods.zip"
		JDK_SHA256="13cc638345c8eaf69d0ec3992e900fecba6220250b7793da87067c239abb2b12"
	;;
	"Darwin arm64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/19.0.2.1/openjfx-19.0.2.1_osx-aarch64_bin-jmods.zip"
		JDK_SHA256="5f638128c29a22880e63c998070b1a5e094dec12234713698f98ed646557fca4"
	;;

	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/19.0.2.1/openjfx-19.0.2.1_windows-x64_bin-jmods.zip"
		JDK_SHA256="b7cf2cad2468842b3b78d99f6c0555771499a36fa1f1ee3dd1b9a4597f1fab86"
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
