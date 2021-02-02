#!/bin/sh

# Java Installer for OpenJDK 15.0.2

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL/openjdk-15.0.2_linux-x64_bin.tar.gz"
		JDK_SHA256="91ac6fc353b6bf39d995572b700e37a20e119a87034eeb939a6f24356fbcd207"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-i586.tar.gz"
		JDK_SHA256="62239fa62a31da34309458a492d6c8d0e88a21141dc78f7e1bbf1bdff5c00c23"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-aarch64.tar.gz"
		JDK_SHA256="254a52b5bb3a6bf96c7b8fc7f278baa6e6f6bb61e0e4ae863b47897f6e1a6768"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="ac387e687763dbb72e9026e563f1bc3f0cb5f504536d9ab2bed1842b8ed05a16"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-ppc64le.tar.gz"
		JDK_SHA256="4a23ad3a6d9ad523da6a4439483bae88995101672bef82fe1dc23acb5ea94b79"
	;;

	"Darwin x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL/openjdk-15.0.2_osx-x64_bin.tar.gz"
		JDK_SHA256="578b17748f5a7d111474bc4c9b5a8a06b4a4aa1ba4a4bc3fef014e079ece7c74"
	;;

	"Windows x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk15.0.2/0d1cfde4252546c6931946de8db48ee2/7/GPL/openjdk-15.0.2_windows-x64_bin.zip"
		JDK_SHA256="ecbe7f32bc6bff2b6c8e9b68f19cbf4ddf54a492c918ba471f32d645cf1c5cf4"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-windows-i586.zip"
		JDK_SHA256="651eccdcc7a45d84e249f6cf1b6be2af1d210576f88f197d0dbf44de38de25de"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/15.0.1/openjfx-15.0.1_linux-x64_bin-jmods.zip"
		JDK_SHA256="eb2472b26391805fe615c444f13df1dd48d1abd5501d847d50216a8519a0ac9c"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/15.0.1/openjfx-15.0.1_osx-x64_bin-jmods.zip"
		JDK_SHA256="c66a77b21d6a5fdc4cfe114e5cbe11f4bc024c4471c7abd95b524eb77b1358e8"
	;;
	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/15.0.1/openjfx-15.0.1_windows-x64_bin-jmods.zip"
		JDK_SHA256="3a0ef198d70de212e33b89b959ba007384ec339fe8537b66e2661c9147365f59"
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
	curl -L -o "$JDK_TAR_GZ" --retry 5 "$JDK_URL"
fi


# verify archive via SHA-256 checksum
JDK_SHA256_ACTUAL=`openssl dgst -sha256 -hex "$JDK_TAR_GZ" | awk '{print $NF}'`
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
