#!/bin/sh

# Unofficial Java Installer for Oracle Java SE 1.8.0_121


# JDK version identifiers
JDK_ARCH=`uname -sm`

case "$JDK_ARCH" in
	"Linux armv7l")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="134c73db663b1fb0f3d771a383dbea1a7cfeaa00e4d2872e0a6df94d242cf2f6"
	;;
	"Linux armv8")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-arm64-vfp-hflt.tar.gz"
		JDK_SHA256="acd84c59aa0c3fa8cfb2e3c51bbd9ebf979b4ed9b5f15b343821c31af2ce3573"
	;;
	"Linux i686")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-i586.tar.gz"
		JDK_SHA256="f7d6cf1468c5e71ff097bec0189caccdd8e709a2a88a2c9849ad6200c0f33d4c"
	;;
	"Linux x86_64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz"
		JDK_SHA256="97e30203f1aef324a07c94d9d078f5d19bb6c50e638e4492722debca588210bc"
	;;
	"Darwin x86_64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jre-8u121-macosx-x64.tar.gz"
		JDK_SHA256="7549541f7843be5cd507bcd91c7195c5dbbe3d222d2b322568e198f2733ba4f0"
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
	curl -v -L -o "$JDK_TAR_GZ" --retry 5 --cookie "oraclelicense=accept-securebackup-cookie" "$JDK_URL"
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
