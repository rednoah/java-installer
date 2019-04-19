#!/bin/sh

# Java Installer for OpenJDK 12

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
		JDK_URL="https://github.com/bell-sw/Liberica/releases/download/12/bellsoft-jdk12-linux-i586-lite.tar.gz"
		JDK_SHA256="c397860ee53e7db2c6693e1a0a95857981acca4962d74b15f666f327849f057d"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://github.com/bell-sw/Liberica/releases/download/12/bellsoft-jdk12-linux-aarch64-lite.tar.gz"
		JDK_SHA256="afdc22765f0d83c55e47d3dd891ccd6f480d652e236e25d02f21a54c8b008ff8"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://github.com/bell-sw/Liberica/releases/download/12/bellsoft-jdk12-linux-arm32-vfp-hflt-lite.tar.gz"
		JDK_SHA256="0cfc100c10d3585ed6c4818e0b2e472d1e4cb9feae22c434ce413e5391104bf1"
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
		JDK_URL="https://github.com/bell-sw/Liberica/releases/download/12/bellsoft-jdk12-windows-i586-lite.zip"
		JDK_SHA256="f13a3a7d803a74f568347f94d77eaf8ddf37d2fc8117d390d1529010a7f19154"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/12/openjfx-12_linux-x64_bin-sdk.zip"
		JDK_SHA256="ac1b80d8cccd423ae2fa20833becaff81d85f24c1b8438a5218d39d4e1d6b5c6"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/12/openjfx-12_osx-x64_bin-sdk.zip"
		JDK_SHA256="85202e2bc793320c5fc8fe9c276f572a3c3fafcf2665fd49f9038e4b71b3f672"
	;;
	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/12/openjfx-12_windows-x64_bin-sdk.zip"
		JDK_SHA256="e5292de96363654320ce6ee6ae9b66cbab965713de85d948a06731a789ce910e"
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
