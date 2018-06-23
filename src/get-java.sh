#!/bin/sh

# @{title} for @{jdk.name} @{jdk.version}

COMMAND=${1:-get}             # get | install
JRE=${2:-jre}                 # jre | jdk
PLATFORM=${3:-`uname -sm`}    # Linux x86_64 | Darwin x86_64 | etc

case "$PLATFORM $JRE" in
	"Linux x86_64 jdk")
		JDK_URL="@{jdk.linux.x64.url}"
		JDK_SHA256="@{jdk.linux.x64.sha256}"
	;;
	"Linux x86_64 jre")
		JDK_URL="@{jre.linux.x64.url}"
		JDK_SHA256="@{jre.linux.x64.sha256}"
	;;
	"Darwin x86_64 jre")
		JDK_URL="@{jre.osx.x64.url}"
		JDK_SHA256="@{jre.osx.x64.sha256}"
	;;
	"Windows x86_64 jre")
		JDK_URL="@{jre.windows.x64.url}"
		JDK_SHA256="@{jre.windows.x64.sha256}"
	;;
	*)
		echo "Architecture not supported: $PLATFORM"
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
