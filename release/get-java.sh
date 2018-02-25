#!/bin/sh

# Unofficial Java Installer for Oracle Java SE 9.0.4


# JDK version identifiers
JDK_ARCH=`uname -sm`

case "$JDK_ARCH" in
	"Linux x86_64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.tar.gz"
		JDK_SHA256="90c4ea877e816e3440862cfa36341bc87d05373d53389ec0f2d54d4e8c95daa2"
	;;
	"Darwin x86_64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jre-9.0.4_osx-x64_bin.tar.gz"
		JDK_SHA256="61145430ffc932ae0119500603e560df0589dcfb96583014a715b52d376e3ccb"
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
