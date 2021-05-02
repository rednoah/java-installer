#!/bin/sh

# Java Installer for OpenJDK 16.0.1

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk16.0.1/7147401fd7354114ac51ef3e1328291f/9/GPL/openjdk-16.0.1_linux-x64_bin.tar.gz"
		JDK_SHA256="b1198ffffb7d26a3fdedc0fa599f60a0d12aa60da1714b56c1defbce95d8b235"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/16.0.1+9/bellsoft-jdk16.0.1+9-linux-i586.tar.gz"
		JDK_SHA256="a33a9b92380759e0e9efc6f3f08cf403cd9dfa4b3fbdefe77bbee67b431b3370"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://download.bell-sw.com/java/16.0.1+9/bellsoft-jdk16.0.1+9-linux-aarch64.tar.gz"
		JDK_SHA256="650f04865bdd3267ab7d1ae459dc34a430b6b6c2c6f04c479f01c728717bda48"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/16.0.1+9/bellsoft-jdk16.0.1+9-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="3b701e52122419e6dd66e1086a2cba7613d63e6fd9073afcce1dfe7e9f1404b7"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://download.bell-sw.com/java/16.0.1+9/bellsoft-jdk16.0.1+9-linux-ppc64le.tar.gz"
		JDK_SHA256="197b45dd685212307fa8affa9bdba0549b826dcafd770e4b20c2feaffd4b787b"
	;;

	"Darwin x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk16.0.1/7147401fd7354114ac51ef3e1328291f/9/GPL/openjdk-16.0.1_osx-x64_bin.tar.gz"
		JDK_SHA256="6098f839954439d4916444757c542c1b8778a32461706812d41cc8bbefce7f2f"
	;;

	"Windows x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk16.0.1/7147401fd7354114ac51ef3e1328291f/9/GPL/openjdk-16.0.1_windows-x64_bin.zip"
		JDK_SHA256="733b45b09463c97133d70c2368f1b9505da58e88f2c8a84358dd4accfd06a7a4"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/16.0.1+9/bellsoft-jdk16.0.1+9-windows-i586.zip"
		JDK_SHA256="429c96779a94a7e9e266acc304c77e79c5524f4d7c1410c62869e1720459e7c7"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/16/openjfx-16_linux-x64_bin-jmods.zip"
		JDK_SHA256="6d9d974119efafc9d3634c588dc4c94315db76d41693d09470b43922557bcfb4"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/16/openjfx-16_osx-x64_bin-jmods.zip"
		JDK_SHA256="054f850ed72a959f524ffa2adbbf7aa13292d85f1e09f414a754e6d40e43ecbc"
	;;
	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/16/openjfx-16_windows-x64_bin-jmods.zip"
		JDK_SHA256="29b5b3086a03e4d991be761be887d6a878cdc5edeab896d9f2e0587a97f7f03f"
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
