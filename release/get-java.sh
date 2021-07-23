#!/bin/sh

# Java Installer for OpenJDK 16.0.2

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_linux-x64_bin.tar.gz"
		JDK_SHA256="6c714ded7d881ca54970ec949e283f43d673a142fda1de79b646ddd619da9c0c"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/16.0.2+7/bellsoft-jdk16.0.2+7-linux-i586.tar.gz"
		JDK_SHA256="94e18199b7b943d4912a2f1df4a2339c1facfb4880206c9303d0755b38fd322e"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_linux-aarch64_bin.tar.gz"
		JDK_SHA256="1ffb9c7748334945d9056b3324de3f797d906fce4dad86beea955153aa1e28fe"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/16.0.2+7/bellsoft-jdk16.0.2+7-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="489f1bc0087e4dc003bcd7c0edf459c4e53eae526fe81f5877d6dcc839c6aa97"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://download.bell-sw.com/java/16.0.2+7/bellsoft-jdk16.0.2+7-linux-ppc64le.tar.gz"
		JDK_SHA256="6fdb703299326bc34c1d9979eeb03c36ece491c69868a0a4b0d7588cf5b146c4"
	;;

	"Darwin x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_osx-x64_bin.tar.gz"
		JDK_SHA256="e65f2437585f16a01fa8e10139d0d855e8a74396a1dfb0163294ed17edd704b8"
	;;

	"Windows x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_windows-x64_bin.zip"
		JDK_SHA256="9df98be05fe674066cc39144467c47b1503cfa3de059c09cc4ccc3da9c253b9a"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/16.0.2+7/bellsoft-jdk16.0.2+7-windows-i586.zip"
		JDK_SHA256="0e069fcabb79c0e19aa50479700543804e3707c38493c4f7e52de2b579c93eb2"
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
		echo "Architecture not supported: $OS $ARCH $TYPE"
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
