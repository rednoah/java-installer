#!/bin/sh

# Unofficial Java Installer for Oracle Java SE 1.8.0_111


# JDK version identifiers
JDK_ARCH=`uname -sm`

case "$JDK_ARCH" in
	"Linux armv7l")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="add3f9685161337fd31e433ea9b19231d6b40561dc40826057930fa2d76d7925"
	;;
	"Linux armv8")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-arm64-vfp-hflt.tar.gz"
		JDK_SHA256="8fd6be278b1d312c53897de66e9bd2e6eb5ce0d5b62da8bbd9b1333dc190ed15"
	;;
	"Linux i686")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-i586.tar.gz"
		JDK_SHA256="9a8e8fcf7b6fbe53d6312195be87ce00f3beaab9dfbaa020b96e305174f39e1f"
	;;
	"Linux x86_64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz"
		JDK_SHA256="187eda2235f812ddb35c352b5f9aa6c5b184d611c2c9d0393afb8031d8198974"
	;;
	"Darwin x86_64")
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jre-8u111-macosx-x64.tar.gz"
		JDK_SHA256="2683617c1a508d70c4dbb1305e83857093606eac00f28c25c468cdd5a52178df"
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
