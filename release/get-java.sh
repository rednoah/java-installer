#!/bin/sh

# Unofficial Java Installer for Oracle Java SE 1.8.0_131


# JDK version identifiers
JDK_ARCH=`uname -sm`

case "$JDK_ARCH" in
	"Linux armv7l")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="4d2677261715e9f0e44972517cf22ae40c69ad4dd1e4c34c88127462b13d4949"
	;;
	"Linux aarch64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-arm64-vfp-hflt.tar.gz"
		JDK_SHA256="8f1d59e35cbea789219f9908d666027ab9015abd8f43999d28d21b43d84c77c2"
	;;
	"Linux i686")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-i586.tar.gz"
		JDK_SHA256="0069a2b1b1cddbefa45f1ff12933fca3b114b6544d536ec0e2d4861a830d7154"
	;;
	"Linux x86_64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz"
		JDK_SHA256="62b215bdfb48bace523723cdbb2157c665e6a25429c73828a32f00e587301236"
	;;
	"Darwin x86_64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jre-8u131-macosx-x64.tar.gz"
		JDK_SHA256="1d868f8de999de7531419b7ed54b73c47923c4f5843da0341c62ee8e4a231ea9"
	;;
	*)
		echo "Architecture not supported: $JDK_ARCH"
		exit 1
	;;
esac


# fetch JDK
JDK_TAR_GZ=`basename $JDK_URL`
if [ ! -f "$JDK_TAR_GZ" ]; then
	echo "Download $JDK_URL"
	curl -fsSL -o "$JDK_TAR_GZ" --retry 5 --cookie "oraclelicense=accept-securebackup-cookie" "$JDK_URL"
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
if [ "$1" != "install" ]; then
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
