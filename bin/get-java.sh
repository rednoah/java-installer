#!/bin/sh

# Java Installer for OpenJDK 21.0.2

COMMAND=${1:-get}        # get | install
TYPE=${2:-jdk}           # jre | jdk
ARCH=${3:-`uname -m`}    # x86_64 | i686 | aarch64 | armv7l | etc
OS=${4:-`uname -s`}      # Linux | Darwin | Windows | etc

case "$OS $ARCH $TYPE" in
	"Linux x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%2B13/OpenJDK21U-jdk_x64_linux_hotspot_21.0.2_13.tar.gz"
		JDK_SHA256="454bebb2c9fe48d981341461ffb6bf1017c7b7c6e15c6b0c29b959194ba3aaa5"
	;;
	"Linux i686 jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.2+14/bellsoft-jdk21.0.2+14-linux-i586.tar.gz"
		JDK_SHA256="647d07f602cc8ea164ad30c09f1ac9979de77ef02c9a8f39d381965b0c25e2b5"
	;;
	"Linux aarch64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%2B13/OpenJDK21U-jdk_aarch64_linux_hotspot_21.0.2_13.tar.gz"
		JDK_SHA256="3ce6a2b357e2ef45fd6b53d6587aa05bfec7771e7fb982f2c964f6b771b7526a"
	;;
	"Linux armv7l jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.2+14/bellsoft-jdk21.0.2+14-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="2a250452e0b7ed3bbffe04c5bdfdd5f979f5da1f415db0839015fa7fba020698"
	;;
	"Linux ppc64le jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%2B13/OpenJDK21U-jdk_ppc64le_linux_hotspot_21.0.2_13.tar.gz"
		JDK_SHA256="d08de863499d8851811c893e8915828f2cd8eb67ed9e29432a6b4e222d80a12f"
	;;
	"Linux riscv64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%2B13/OpenJDK21U-jdk_riscv64_linux_hotspot_21.0.2_13.tar.gz"
		JDK_SHA256="791a37ddb040e1a02bbfc61abfbc7e7321431a28054c9ac59ba1738fd5320b02"
	;;

	"Darwin x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%2B13/OpenJDK21U-jdk_x64_mac_hotspot_21.0.2_13.tar.gz"
		JDK_SHA256="ba696ec46c1ca2b1b64c4e9838e21a2d62a1a4b6857a0770adc64451510065db"
	;;
	"Darwin arm64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%2B13/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.2_13.tar.gz"
		JDK_SHA256="57d9e0f0e8639f9f2fb1837518fd83043f23953ff69a677f885aa060994d0c19"
	;;

	"Windows x86_64 jdk")
		JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.2%2B13/OpenJDK21U-jdk_x64_windows_hotspot_21.0.2_13.zip"
		JDK_SHA256="8780b07ae0a9836285a86a5b6d2b8a0b82acf97258622d44c619d59998a1da7b"
	;;
	"Windows x86 jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.2+14/bellsoft-jdk21.0.2+14-windows-i586.zip"
		JDK_SHA256="7577c6dc8db087717270874df2fb2282f118c1fb727a96e67e7b2e11a00e4dff"
	;;
	"Windows aarch64 jdk")
		JDK_URL="https://download.bell-sw.com/java/21.0.2+14/bellsoft-jdk21.0.2+14-windows-aarch64.zip"
		JDK_SHA256="b2fa1d2fd47a8344b547541eaa5603a4569739347b7875f15afb0f54afa73bb4"
	;;

	"Linux x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.2/openjfx-21.0.2_linux-x64_bin-jmods.zip"
		JDK_SHA256="49703558356649ef1335d12839f55b4c391d72a2e43a525638f1a38c799a6fdc"
	;;

	"Darwin x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.2/openjfx-21.0.2_osx-x64_bin-jmods.zip"
		JDK_SHA256="9192802e1dbe19781a2c38f82961677065202b3c9f701f1e0fa08bfe05cc0e74"
	;;
	"Darwin arm64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.2/openjfx-21.0.2_osx-aarch64_bin-jmods.zip"
		JDK_SHA256="5d12bc422a4d9ed29c6b40979a6009a00b86a677971fdff5314b879136e39688"
	;;

	"Windows x86_64 jfx")
		JDK_URL="https://download2.gluonhq.com/openjfx/21.0.2/openjfx-21.0.2_windows-x64_bin-jmods.zip"
		JDK_SHA256="de0dd27cc237897481f58cfb90855825d0ad36682838eed27b79e061eeb79d68"
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
