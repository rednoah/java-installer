#!/bin/sh

# Java Installer for OpenJDK 11.0.2

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk11/7/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz"
		JDK_SHA256="62ee5758af12bbad04f376bf2b61f114076f6d8ffe4ba8db13bb5a63b5ef0d29"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://github.com/bell-sw/Liberica/releases/download/11.0.1/bellsoft-jdk11.0.1-linux-aarch64-lite.tar.gz"
		JDK_SHA256="7f354889950fea7c7dcebfc9bfe37a6f623b62d7db097fbd712011bbae407058"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://github.com/bell-sw/Liberica/releases/download/11.0.1/bellsoft-jdk11.0.1-linux-arm32-vfp-hflt-lite.tar.gz"
		JDK_SHA256="c9d22b8809497efedcef253641b11da9c394d3fd546d35556c8d165210bd8bdf"
	;;
	"Darwin x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk11/7/GPL/openjdk-11.0.2_osx-x64_bin.tar.gz"
		JDK_SHA256="0724f0a2e6509a2a20c3238660e33d45b2137f6d82db5c5ebd1c0592210ce948"
	;;
	"Windows x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk11/7/GPL/openjdk-11.0.2_windows-x64_bin.zip"
		JDK_SHA256="74b13684729a249d32fd955fd1de2bec22e627f6a6a5894ca74f88c945c95f55"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/11.0.2/openjfx-11.0.2_linux-x64_bin-sdk.zip"
		JDK_SHA256="40ef06cd50ea535d45403d9c44e9cb405b631c547734b5b50a6cb7b222293f97"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/11.0.2/openjfx-11.0.2_osx-x64_bin-sdk.zip"
		JDK_SHA256="e98158812db1a0037cdaf85824adff384e41e3edf046fda145479ce6057cb514"
	;;
	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/11.0.2/openjfx-11.0.2_windows-x64_bin-sdk.zip"
		JDK_SHA256="2dd008e0c865f9bc02abd4aaf11ceeb15ca5bfe8c434e613501feda60528ce61"
	;;

	*)
		echo "Architecture not supported: $OS $ARCH"
		exit 1
	;;
esac


# fetch JDK
JDK_TAR_GZ=`basename $JDK_URL`
if [ ! -f "$JDK_TAR_GZ" ]; then
	echo "Download $JDK_URL"
	curl -fsSL -o "$JDK_TAR_GZ" --retry 5 "$JDK_URL"
fi


# verify archive via SHA-256 checksum
JDK_SHA256_ACTUAL=`openssl dgst -sha256 -hex "$JDK_TAR_GZ" | egrep --only-matching "[a-f0-9]{64}"`
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
