#!/bin/sh

# Java Installer for OpenJDK 12.0.1

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_linux-x64_bin.tar.gz"
		JDK_SHA256="151eb4ec00f82e5e951126f572dc9116104c884d97f91be14ec11e85fc2dd626"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/12.0.1/bellsoft-jdk12.0.1-linux-i586.tar.gz"
		JDK_SHA256="b267c658281f8cb3fa0cf92b2b24e34e0d41a57aab83685a9dcc8dc8680833a8"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://download.bell-sw.com/java/12.0.1/bellsoft-jdk12.0.1-linux-aarch64.tar.gz"
		JDK_SHA256="037177804b80177edcbab30c5612f0fc13e611f6d9287642c831f00b9b7fe188"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/12.0.1/bellsoft-jdk12.0.1-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="f9b1e45c310f45ec3a6804345a0c64f632ac7f2ae6258cf1b7b73009a1e57651"
	;;
	"Darwin x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_osx-x64_bin.tar.gz"
		JDK_SHA256="cba6f42f82496f62c51fb544e243d440984d442bdc906550a30428d8be6189e5"
	;;
	"Windows x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk12.0.1/69cfe15208a647278a19ef0990eea691/12/GPL/openjdk-12.0.1_windows-x64_bin.zip"
		JDK_SHA256="fc7d9eee3c09ea6548b00ca25dbf34a348b3942c815405a1428e0bfef268d08d"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/12.0.1/bellsoft-jdk12.0.1-windows-i586.zip"
		JDK_SHA256="4c39ab2aa5c246c377702693d462f17cdd5d85ca55aad0f270eda5063d95e4b0"
	;;

	"Windows x86_64 jre")
		JDK_URL="https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1+12/OpenJDK12U-jre_x64_windows_hotspot_12.0.1_12.zip"
		JDK_SHA256="415242a5dd288fa3559a729912ff79916f5c74827c7819980912285165ad2d3a"
	;;
	"Darwin x86_64 jre")
		JDK_URL="https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1+12/OpenJDK12U-jre_x64_mac_hotspot_12.0.1_12.tar.gz"
		JDK_SHA256="a739b9b828ee1e83830739180af1c1f070431bba3812ab4f067dfca18e163b2a"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/12.0.1/openjfx-12.0.1_linux-x64_bin-sdk.zip"
		JDK_SHA256="8de2c84a5844341d140074f5070deca1f7865733ef0176a8114540a9db2e4657"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/12.0.1/openjfx-12.0.1_osx-x64_bin-sdk.zip"
		JDK_SHA256="6915fcec618dda0fdb0a46bd15db11e3cafba5b213e1f818bd64543cc25abf6c"
	;;
	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/12.0.1/openjfx-12.0.1_windows-x64_bin-sdk.zip"
		JDK_SHA256="3af29fe7d8ded403f0653d16f8da6d431c176d476b63479205b7488c14c33d98"
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
