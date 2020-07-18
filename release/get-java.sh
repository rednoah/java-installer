#!/bin/sh

# Java Installer for OpenJDK 14.0.2

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_linux-x64_bin.tar.gz"
		JDK_SHA256="91310200f072045dc6cef2c8c23e7e6387b37c46e9de49623ce0fa461a24623d"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-i586.tar.gz"
		JDK_SHA256="f63478004ca7ddf9d5872bc24b4fd04ec9e904dfd963e45bbbbecd5bb93d410a"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-aarch64.tar.gz"
		JDK_SHA256="2360eb766e60909b0ac26d4a6debc291b040ec09160b5e27b75d0500778252ce"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="78006d57b8793cccc112c12db6b7db53c9ab2d441285a6fad2da331258eee615"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-linux-ppc64le.tar.gz"
		JDK_SHA256="ca50c4dc595133a2dae2360d3e10d663f9e94597319594726aaa0df9d5c36372"
	;;
	"Darwin x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_osx-x64_bin.tar.gz"
		JDK_SHA256="386a96eeef63bf94b450809d69ceaa1c9e32a97230e0a120c1b41786b743ae84"
	;;
	"Windows x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk14.0.2/205943a0976c4ed48cb16f1043c5c647/12/GPL/openjdk-14.0.2_windows-x64_bin.zip"
		JDK_SHA256="20600c0bda9d1db9d20dbe1ab656a5f9175ffb990ef3df6af5d994673e4d8ff9"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/14.0.2+13/bellsoft-jdk14.0.2+13-windows-i586.zip"
		JDK_SHA256="aa5cb80259f163577f17bcfa1ff6d2eee8aab9081c952eeef18ba4c51871f99b"
	;;

	"Windows x86_64 jre")
		JDK_URL="https://download.bell-sw.com/java/14.0.2+13/bellsoft-jre14.0.2+13-windows-amd64.zip"
		JDK_SHA256="b34af586813958299c2b0386c74a0404dac6712e7b7168e1b7aeec394cfd7010"
	;;
	"Darwin x86_64 jre")
		JDK_URL="https://download.bell-sw.com/java/14.0.2+13/bellsoft-jre14.0.2+13-macos-amd64.zip"
		JDK_SHA256="a2853bfd9bd6ec23c29bfcfb1b1aec30ad6d73c6ba954a13ec26b70a33e24d82"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/14.0.2/openjfx-14.0.2_linux-x64_bin-sdk.zip"
		JDK_SHA256="f676b8605d2e582ffeb969ddcdc9972d2b0053acd4b9dacad8d2579f8f2b30a7"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/14.0.2/openjfx-14.0.2_osx-x64_bin-sdk.zip"
		JDK_SHA256="a38fd615eecfa40ba5994942fee9f2b726e3d1bd943341488b0ef14062a8ffab"
	;;
	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/14.0.2/openjfx-14.0.2_windows-x64_bin-sdk.zip"
		JDK_SHA256="d34c8656d2ecd5afcc921a20872c6476bf460d12a674600ce09017ecfa328ed5"
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
