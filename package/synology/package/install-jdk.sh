#!/bin/sh

# JDK version identifiers
JDK_VERSION="8u65"
JDK_BUILD="b17"

# fetch JDK for this architecture
case `uname -m` in
	armv7l)
		JDK_ARCH="linux-arm32-vfp-hflt"
		JDK_SHA256="35855580355584865bade416d23cc164792d7fa2581a140e6034724c520be45c"
	;;
	armv8)
		JDK_ARCH="linux-arm64-vfp-hflt"
		JDK_SHA256="29ead39d88c2fbf5eebf126ded24c2a129227a3ae9f255f1b5688a2403912527"
	;;
	i686)
		JDK_ARCH="linux-i586"
		JDK_SHA256="cf1903cfae652bea4f9ec94635cd0791e038f5bf2babeb778c1711c32b8a19ea"
	;;
	x86_64)
		JDK_ARCH="linux-x64"
		JDK_SHA256="88db2aacdc222c2add4d92822f528b7a2101552272db4487f33b38b0b47826e7"
	;;
	*)
		echo "Unkown CPU architecture: `uname -m`"
		exit 1
	;;
esac

JDK_TAR="jdk-$JDK_VERSION-$JDK_ARCH.tar.gz"
JDK_URL="http://download.oracle.com/otn-pub/java/jdk/$JDK_VERSION-$JDK_BUILD/$JDK_TAR"


# enter version-specific working directory
mkdir -p "jdk-$JDK_VERSION-$JDK_ARCH"
cd "jdk-$JDK_VERSION-$JDK_ARCH"

# fetch JDK
echo "Download $JDK_URL"
curl -v -L -o "$JDK_TAR" --cookie "oraclelicense=accept-securebackup-cookie" "$JDK_URL"

# verify archive via SHA-256 checksum
JDK_SHA256_ACTUAL=`openssl dgst -sha256 -hex -r "$JDK_TAR" | cut -d' ' -f1`
echo "Expected SHA256 checksum: $JDK_SHA256"
echo "Actual SHA256 checksum: $JDK_SHA256_ACTUAL"

if [ "$JDK_SHA256" != "$JDK_SHA256_ACTUAL" ]; then
	echo "ERROR: SHA256 checksum mismatch"
	exit 1
fi

echo "Extract $JDK_TAR"
tar -v -zxf "$JDK_TAR"

# find latest java executable
JAVA_EXE=`find "$PWD" -name "java" -type f -print0 | xargs -0 ls -Alt1 | head -n 1  | sed -e 's/\s\+/\s /g' | cut -d' ' -f7-`

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
