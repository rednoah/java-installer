#!/bin/sh

# Java Installer for OpenJDK 11.0.2

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz"
		JDK_SHA256="99be79935354f5c0df1ad293620ea36d13f48ec3ea870c838f20c504c9668b57"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://github.com/bell-sw/Liberica/releases/download/11.0.2/bellsoft-jdk11.0.2-linux-aarch64.tar.gz"
		JDK_SHA256="3ab8376175e283557634ee7b7bc5881e9db7141ff08bd56f48b7218226f0866c"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://github.com/bell-sw/Liberica/releases/download/11.0.2/bellsoft-jdk11.0.2-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="ac407bcbf0c7e1b3bf47291b0116db8e5da884fa0d9a4b3aed42632b54e57b2a"
	;;
	"Darwin x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_osx-x64_bin.tar.gz"
		JDK_SHA256="f365750d4be6111be8a62feda24e265d97536712bc51783162982b8ad96a70ee"
	;;
	"Windows x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_windows-x64_bin.zip"
		JDK_SHA256="cf39490fe042dba1b61d6e9a395095279a69e70086c8c8d5466d9926d80976d8"
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
