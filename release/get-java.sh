#!/bin/sh

# Java Installer for OpenJDK 15.0.2+10

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-amd64.tar.gz"
		JDK_SHA1="d390c4e9fa3df8373548959329ec6b157e9194b6"
	;;
	"Linux x86_64 jre")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jre15.0.2+10-linux-amd64.tar.gz"
		JDK_SHA1="95b3b34dbfa1d6d5616a46aa1f56f67c663df35f"
	;;	
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-i586.tar.gz"
		JDK_SHA1="95cf3931193d33205c133503e9dc5a79060b6f9c"
	;;
	"Linux i686 jre")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jre15.0.2+10-linux-i586.tar.gz"
		JDK_SHA1="bb0643e083e6cca605c0833d138ecce9ae927a85"
	;;	
	"Linux aarch64 jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-aarch64.tar.gz"
		JDK_SHA1="e774f58d0d84cddfa26635c0050005715b1cc47c"
	;;
	"Linux aarch64 jre")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jre15.0.2+10-linux-aarch64.tar.gz"
		JDK_SHA1="fa96fe2ffa2e3464244654bc0cbe3f245624bea8"
	;;	
	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA1="b88bd58ed49e5d626486a883f4247c36e90b00c5"
	;;
	"Linux armv7l jre")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jre15.0.2+10-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA1="391191812af1c2f8f2f1dad32f4e4f337d679070"
	;;	
	"Linux ppc64le jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-linux-ppc64le.tar.gz"
		JDK_SHA1="55101d6b0126cbaac54ac7e612e698622432f0fb"
	;;
	"Linux ppc64le jre")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jre15.0.2+10-linux-ppc64le.tar.gz"
		JDK_SHA1="5cfe672dbe62061fdd1ed2ab66ff46fe68b50507"
	;;	

	"Darwin x86_64 jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-macos-amd64.zip"
		JDK_SHA1="ddfd33ae1bc6c8ee25b79836b8972c8b4b359dba"
	;;

	"Windows x86_64 jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-windows-amd64.zip"
		JDK_SHA1="5d29500deb98111073de8f70ba2b805ef5b02b98"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/15.0.2+10/bellsoft-jdk15.0.2+10-windows-i586.zip"
		JDK_SHA1="dca8ede3b2a1fddacadfc74cd9b77e23436c7f78"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/15.0.1/openjfx-15.0.1_linux-x64_bin-jmods.zip"
		JDK_SHA1="b7416f33ace0e67b31dde77148e7ac9639a522bd"
	;;
	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/15.0.1/openjfx-15.0.1_osx-x64_bin-jmods.zip"
		JDK_SHA1="7f7e4b1f03f2e9e18d4702ab8bc629f479a39d14"
	;;
	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/15.0.1/openjfx-15.0.1_windows-x64_bin-jmods.zip"
		JDK_SHA1="22915083d8070d252ffc7a1f1c75438c79192d84"
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


# verify archive via SHA1 checksum
JDK_SHA1_ACTUAL=`openssl dgst -sha1 -hex "$JDK_TAR_GZ" | awk '{print $NF}'`
echo "Expected SHA1 checksum: $JDK_SHA1"
echo "Actual SHA1 checksum: $JDK_SHA1_ACTUAL"

if [ "$JDK_SHA1" != "$JDK_SHA1_ACTUAL" ]; then
	echo "ERROR: SHA1 checksum mismatch"
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
