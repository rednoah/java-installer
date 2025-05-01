#!/bin/sh

# Java Installer for OpenJDK 21.0.4

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_x64_linux_hotspot_21.0.4_7.tar.gz"
		JDK_SHA256="51fb4d03a4429c39d397d3a03a779077159317616550e4e71624c9843083e7b9"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.4+9/bellsoft-jdk21.0.4+9-linux-i586.tar.gz"
		JDK_SHA256="b71b565f674d6df46c88f51239bdfff2df074956f37f430d2556e1c66d9327bd"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.4_7.tar.gz"
		JDK_SHA256="d768eecddd7a515711659e02caef8516b7b7177fa34880a56398fd9822593a79"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.4+9/bellsoft-jdk21.0.4+9-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="a5ae23e5ca3df5322185f420c20fc80d48a1146f84219556fff05fbb16bf2375"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.4_7.tar.gz"
		JDK_SHA256="c208cd0fb90560644a90f928667d2f53bfe408c957a5e36206585ad874427761"
	;;
	"Linux riscv64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_riscv64_linux_hotspot_21.0.4_7.tar.gz"
		JDK_SHA256="b04fd7f52d18268a935f1a7144dae802b25db600ec97156ddd46b3100cbd13da"
	;;

	"Darwin x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_x64_mac_hotspot_21.0.4_7.tar.gz"
		JDK_SHA256="e368e5de7111aa88e6bbabeff6f4c040772b57fb279cc4e197b51654085bbc18"
	;;
	"Darwin arm64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.4_7.tar.gz"
		JDK_SHA256="dcf69a21601d9b1b25454bbad4f0f32784bb42cdbe4063492e15a851b74cb61e"
	;;

	"Windows x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_x64_windows_hotspot_21.0.4_7.zip"
		JDK_SHA256="c725540d911531c366b985e5919efc8a73dd4030965cd9a740c3d2cd92c72c74"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.4+9/bellsoft-jdk21.0.4+9-windows-i586.zip"
		JDK_SHA256="ba50bb65f2a4ecc575532a35cec50a92b90af0bde49b07599d651add9e845c52"
	;;
	"Windows aarch64 jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.4+9/bellsoft-jdk21.0.4+9-windows-aarch64.zip"
		JDK_SHA256="49fd9fc0b838ee5b57dedf483194cb5de3f5a5e6453115843c05b920edbb417e"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.4/openjfx-21.0.4_linux-x64_bin-jmods.zip"
		JDK_SHA256="2412d689c724f60c39ea878d8a3bd4c6abfb5d9856cafc1cc8a49e28dc12d221"
	;;

	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.4/openjfx-21.0.4_osx-x64_bin-jmods.zip"
		JDK_SHA256="094c7e71c54473cf71086a67d4bfefa7c4fd6c6eb8d0f8be4785657c6c087e23"
	;;
	"Darwin arm64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.4/openjfx-21.0.4_osx-aarch64_bin-jmods.zip"
		JDK_SHA256="d510f6d13f522d5e5c4379bc3fea081da608aef62b77861dd0298af42529bf27"
	;;

	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.4/openjfx-21.0.4_windows-x64_bin-jmods.zip"
		JDK_SHA256="f7cfa8e0e636c5cdf0f6aced810e703131783bf3d295797475e341b77fb037ee"
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
