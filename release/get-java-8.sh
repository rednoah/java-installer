#!/bin/sh

# Java 8 Installer for Oracle Java SE 1.8.0_201


# JDK version identifiers
JDK_ARCH=`uname -sm`

case "$JDK_ARCH" in
	"Linux armv7l")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="5103b9e33ac3aa353f06b11976a496b4cc09dd6d6614c5cc0ec2693a12decb78"
	;;
	"Linux aarch64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-arm64-vfp-hflt.tar.gz"
		JDK_SHA256="f81077bf8a9c8fcd3b35b6431da8f8aaec7156ad5fb7aa29fd98d2f49ef6cbaf"
	;;
	"Linux i686")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-i586.tar.gz"
		JDK_SHA256="4ce13fa548631f288a232332f94db2f6f7ad155ee44236bb82ecbd59ff4836b9"
	;;
	"Linux x86_64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.tar.gz"
		JDK_SHA256="cb700cc0ac3ddc728a567c350881ce7e25118eaf7ca97ca9705d4580c506e370"
	;;
	"Darwin x86_64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jre-8u201-macosx-x64.tar.gz"
		JDK_SHA256="99d71ff6579429b96627729f5c2aa571cff7a83bfe5084bb148a970fb46e60b7"
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
JDK_SHA256_ACTUAL=`openssl dgst -sha256 -hex "$JDK_TAR_GZ" | egrep -o "[a-f0-9]{64}"`
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
JAVA_EXE=`find "$PWD" -name "java" -type f | grep -v /jre/ | sort | tail -n 1`

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
