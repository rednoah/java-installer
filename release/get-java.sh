#!/bin/sh

# Java Installer for OpenJDK 11.0.1

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz"
		JDK_SHA256="7a6bb980b9c91c478421f865087ad2d69086a0583aeeb9e69204785e8e97dcfd"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://github.com/bell-sw/Liberica/releases/download/11/bellsoft-jdk11-linux-aarch64-lite.tar.gz"
		JDK_SHA256="b80941aa5ccefa24ab3e1584e1301ddac2c436eefa03cffcffb43bae5bd526be"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://github.com/bell-sw/Liberica/releases/download/11/bellsoft-jdk11-linux-arm32-vfp-hflt-lite.tar.gz"
		JDK_SHA256="f3469cdff77dfc940352bf86893805f7125cffd1cc72342b6a51627bb8307b75"
	;;
	"Darwin x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_osx-x64_bin.tar.gz"
		JDK_SHA256="fa07eee08fa0f3de541ee1770de0cdca2ae3876f3bd78c329f27e85c287cd070"
	;;
	"Windows x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_windows-x64_bin.zip"
		JDK_SHA256="289dd06e06c2cbd5e191f2d227c9338e88b6963fd0c75bceb9be48f0394ede21"
	;;

	"Linux x86_64 jfx")
		JDK_URL="http://download2.gluonhq.com/openjfx/11.0.1/openjfx-11.0.1_linux-x64_bin-sdk.zip"
		JDK_SHA256="678aeffe0574e90c59fc1f26628662878529213024abf49cb309f3ecadc3b91b"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="http://download2.gluonhq.com/openjfx/11.0.1/openjfx-11.0.1_osx-x64_bin-sdk.zip"
		JDK_SHA256="944d9d92d81389e336dd2b308b01ed6f05e2facb17aa8cfb8e544d47c36c910"
	;;
	"Windows x86_64 jfx")
		JDK_URL="http://download2.gluonhq.com/openjfx/11.0.1/openjfx-11.0.1_windows-x64_bin-sdk.zip"
		JDK_SHA256="b80021b37fca7a2c67f15e1b32f862120080c0260bc662631abdcdbf9cbbdb7"
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
