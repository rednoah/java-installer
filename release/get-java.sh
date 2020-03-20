#!/bin/sh

# Java Installer for OpenJDK 14

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_linux-x64_bin.tar.gz"
		JDK_SHA256="c7006154dfb8b66328c6475447a396feb0042608ee07a96956547f574a911c09"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/14+36/bellsoft-jdk14+36-linux-i586.tar.gz"
		JDK_SHA256="364157d6b979115026ba9e9b346fdef34a5cc421868dc5a58d443d1c38332a19"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://download.bell-sw.com/java/14+36/bellsoft-jdk14+36-linux-aarch64.tar.gz"
		JDK_SHA256="b63dc386a5cc3ef53d8db5bb6a8fae0f956a2c2621b39a15edb7726e9d7ff4c7"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/14+36/bellsoft-jdk14+36-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="dd73a5214c8687ccd16e2921c2e88ae9586830d90b420a423a1f7dad5b509461"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://download.bell-sw.com/java/14+36/bellsoft-jdk14+36-linux-ppc64le.tar.gz"
		JDK_SHA256="d0ab4b4539908de4896273077024941bed89e15c18cca67b3f22a7b0e5eb8539"
	;;
	"Darwin x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_osx-x64_bin.tar.gz"
		JDK_SHA256="f3e7439e19ea22f71a96b5563e0e0967e7df1563f2f9d7922209793498ca4698"
	;;
	"Windows x86_64 jdk")
		JDK_URL="https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_windows-x64_bin.zip"
		JDK_SHA256="6b56c65c2ebb89eb361f47370359f88c4b87234dc073988a2c33e7d75c01e488"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/14+36/bellsoft-jdk14+36-windows-i586.zip"
		JDK_SHA256="7712f8843a9a8fbf5a95b6b573b6a56d9d03c1e3dcf6799f9f13d13f3160dbc4"
	;;

	"Windows x86_64 jre")
		JDK_URL="https://download.bell-sw.com/java/14+36/bellsoft-jre14+36-windows-amd64.zip"
		JDK_SHA256="a3d3e972ee9fc87b2de1022da99433c75eaec18b494e07c4c82763760bd63d8c"
	;;
	"Darwin x86_64 jre")
		JDK_URL="https://download.bell-sw.com/java/14+36/bellsoft-jre14+36-macos-amd64.zip"
		JDK_SHA256="ae7f41a427caa95648b0bbbed98970e9943322dfe31fe70a7d3c46b805d2377f"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/14/openjfx-14_linux-x64_bin-sdk.zip"
		JDK_SHA256="dc0ce35ba41956b08fe62e2db9b8cf6dd80ba21716564d78ad652ddd945d6dbd"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/14/openjfx-14_osx-x64_bin-sdk.zip"
		JDK_SHA256="2248313482e949d43176b60bce0646d27a5891fb01ead0e4e820de917b3e5b4d"
	;;
	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/14/openjfx-14_windows-x64_bin-sdk.zip"
		JDK_SHA256="5eda8cf6c27fae9db64035b53c855cb248b7f356835af072dc1a23b13961ea8b"
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
