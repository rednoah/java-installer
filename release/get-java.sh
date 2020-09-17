#!/bin/sh

# Java Installer for OpenJDK 15

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk15/779bf45e88a44cbd9ea6621d33e33db1/36/GPL/openjdk-15_linux-x64_bin.tar.gz"
		JDK_SHA256="bb67cadee687d7b486583d03c9850342afea4593be4f436044d785fba9508fb7"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/15+36/bellsoft-jdk15+36-linux-i586.tar.gz"
		JDK_SHA256="4398ce560b5466a9fbd478cf4a2ed19c94056d438f9a9e033c77b80e4e390e79"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://download.bell-sw.com/java/15+36/bellsoft-jdk15+36-linux-aarch64.tar.gz"
		JDK_SHA256="5e8751ead7d0ab561bb6359b9be65ac0fb3db3e561111b0606fbde7f60169e64"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/15+36/bellsoft-jdk15+36-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="3adab30c8d9ad8be7b26d8b2cb5ab13052959b4de40a1131d11a668c4e33ae5a"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://download.bell-sw.com/java/15+36/bellsoft-jdk15+36-linux-ppc64le.tar.gz"
		JDK_SHA256="f3739722858fb4011baece204b8cd54bd3b1c813e3e21c7156d641c0f6f357aa"
	;;
	"Darwin x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk15/779bf45e88a44cbd9ea6621d33e33db1/36/GPL/openjdk-15_osx-x64_bin.tar.gz"
		JDK_SHA256="ab842c8c0953b816be308c098c1a021177a4776bef24da85b6bafbbd657c7e1a"
	;;
	"Windows x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk15/779bf45e88a44cbd9ea6621d33e33db1/36/GPL/openjdk-15_windows-x64_bin.zip"
		JDK_SHA256="764e39a71252a9791118a31ae56a4247c049463bda5eb72497122ec50b1d07f8"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/15+36/bellsoft-jdk15+36-windows-i586.zip"
		JDK_SHA256="fe3b41d6821dac9a56e5b2cd2a1ec29be4ad791a8338622ef30802057b268028"
	;;

	"Windows x86_64 jre")
		JDK_URL="https://download.bell-sw.com/java/15+36/bellsoft-jre15+36-windows-amd64.zip"
		JDK_SHA256="b87594ee77f1472f719a1252e2aadc1f766d20ca94681203f6c738efad8ce2f3"
	;;
	"Darwin x86_64 jre")
		JDK_URL="https://download.bell-sw.com/java/15+36/bellsoft-jre15+36-macos-amd64.zip"
		JDK_SHA256="83da85dfa7686e4ba5aad38491e196f7f2866f5945d24ee4f5ad2e0e5f020974"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/15/openjfx-15_linux-x64_bin-sdk.zip"
		JDK_SHA256="8b4401644094c5e5e30e7ee00334aa1d27323aa648f2e7c8d3358208c2907b50"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/15/openjfx-15_osx-x64_bin-sdk.zip"
		JDK_SHA256="f7bba4097017175401cfde913b551a42a4ee331ac8526bd26a727289e7839ab4"
	;;
	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/15/openjfx-15_windows-x64_bin-sdk.zip"
		JDK_SHA256="a7f619492c34bf823ea131e1b6605339ebe94de6168c809e27e5fa3c00e41fa7"
	;;

	*)
		echo "Architecture not supported: $OS $ARCH"
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
if [ "$COMMAND $TYPE" != "install jdk" ]; then
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
