#!/bin/sh

# Java Installer for OpenJDK 17.0.2

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_x64_linux_hotspot_17.0.2_8.tar.gz"
		JDK_SHA256="288f34e3ba8a4838605636485d0365ce23e57d5f2f68997ac4c2e4c01967cd48"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/17.0.2+9/bellsoft-jdk17.0.2+9-linux-i586.tar.gz"
		JDK_SHA256="7bc5857e9e5520074e93d38e71bb335ba99b700c74effeb4177d57c2c6d305b2"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.2_8.tar.gz"
		JDK_SHA256="302caf29f73481b2b914ba2b89705036010c65eb9bc8d7712b27d6e9bedf6200"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_arm_linux_hotspot_17.0.2_8.tar.gz"
		JDK_SHA256="544936145a4a9b1a316ed3708cd91b3960d5e8e87578bea73ef674ca3047158e"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_ppc64le_linux_hotspot_17.0.2_8.tar.gz"
		JDK_SHA256="532d831d6a977e821b7331ecf9ed995e5bbfe76f18a1b00ffa8dbb3a4e2887de"
	;;

	"Darwin x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_x64_mac_hotspot_17.0.2_8.tar.gz"
		JDK_SHA256="3630e21a571b7180876bf08f85d0aac0bdbb3267b2ae9bd242f4933b21f9be32"
	;;
	"Darwin arm64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.2_8.tar.gz"
		JDK_SHA256="157518e999d712b541b883c6c167f8faabbef1d590da9fe7233541b4adb21ea4"
	;;

	"Windows x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_x64_windows_hotspot_17.0.2_8.zip"
		JDK_SHA256="d083479ca927dce2f586f779373d895e8bf668c632505740279390384edf03fa"
	;;
	"Windows x86 jdk")
		JDK_URL="@{jdk.windows.x32.url}"
		JDK_SHA256="@{jdk.windows.x32.sha256}"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/17.0.2/openjfx-17.0.2_linux-x64_bin-jmods.zip"
		JDK_SHA256="61310348a4017b295c19f1061f8ab52d66e16b65eadc6daffee40b68e0ea2b9e"
	;;
	"Linux aarch64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/17.0.2/openjfx-17.0.2_linux-aarch64_bin-jmods.zip"
		JDK_SHA256="2ebd0a82bd55776d853a02c2503aeb5cd21a5f3ed1f33c703c9283975a3cc378"
	;;

	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/17.0.2/openjfx-17.0.2_osx-x64_bin-jmods.zip"
		JDK_SHA256="b847f01ef1ce0b601348b57efa14701482b29df66bcf17ab3a38a5095bb759b6"
	;;
	"Darwin arm64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/17.0.2/openjfx-17.0.2_osx-aarch64_bin-jmods.zip"
		JDK_SHA256="044a6aa0d8dead73565a3d0fcc6b3b4f63439a130acdc190d5a704a33b50ff0f"
	;;

	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/17.0.2/openjfx-17.0.2_windows-x64_bin-jmods.zip"
		JDK_SHA256="46620068bbe216e4a31576e3339c676e6ed67976302748d8330f1068f65acea8"
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
