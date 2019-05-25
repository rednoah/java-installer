#!/bin/sh

# @{title} for @{jdk.name} @{jdk.version}

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="@{jdk.linux.x64.url}"
		JDK_SHA256="@{jdk.linux.x64.sha256}"
	;;
	"Linux i686 jdk")
		JDK_URL="@{jdk.linux.x86.url}"
		JDK_SHA256="@{jdk.linux.x86.sha256}"
	;;
	"Linux aarch64 jdk")
		JDK_URL="@{jdk.linux.aarch64.url}"
		JDK_SHA256="@{jdk.linux.aarch64.sha256}"
	;;
	"Linux armv7l jdk")
		JDK_URL="@{jdk.linux.armv7l.url}"
		JDK_SHA256="@{jdk.linux.armv7l.sha256}"
	;;
	"Darwin x86_64 jdk")
		JDK_URL="@{jdk.mac.x64.url}"
		JDK_SHA256="@{jdk.mac.x64.sha256}"
	;;
	"Windows x86_64 jdk")
		JDK_URL="@{jdk.windows.x64.url}"
		JDK_SHA256="@{jdk.windows.x64.sha256}"
	;;
	"Windows x86 jdk")
		JDK_URL="@{jdk.windows.x86.url}"
		JDK_SHA256="@{jdk.windows.x86.sha256}"
	;;

	"Windows x86_64 jre")
		JDK_URL="@{jre.windows.x64.url}"
		JDK_SHA256="@{jre.windows.x64.sha256}"
	;;
	"Darwin x86_64 jre")
		JDK_URL="@{jre.mac.x64.url}"
		JDK_SHA256="@{jre.mac.x64.sha256}"
	;;

	"Linux x86_64 jfx")
		JDK_URL="@{jfx.linux.x64.url}"
		JDK_SHA256="@{jfx.linux.x64.sha256}"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="@{jfx.mac.x64.url}"
		JDK_SHA256="@{jfx.mac.x64.sha256}"
	;;
	"Windows x86_64 jfx")
		JDK_URL="@{jfx.windows.x64.url}"
		JDK_SHA256="@{jfx.windows.x64.sha256}"
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
JDK_SHA256_ACTUAL=`openssl dgst -sha256 -hex "$JDK_TAR_GZ" | egrep -o "[a-f0-9]{64}"`
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
