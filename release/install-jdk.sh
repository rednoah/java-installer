#!/bin/sh

# Unofficial Java Installer for Oracle Java SE 1.8.0_77
# Example: curl -O https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jdk.sh && sh -x install-jdk.sh

# JDK version identifiers
case `uname -m` in
	armv7l)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="c3af7a080cd74f7350680a020749b8161f78f66d1f16cda91bf758c3e58b524b"
	;;
	armv8)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-arm64-vfp-hflt.tar.gz"
		JDK_SHA256="d194595d0c6d2f0b6fad36da489e26a65e3825af85c051ce3c84d5a1f5a96b31"
	;;
	i686)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-i586.tar.gz"
		JDK_SHA256="f2889b778538fe3d20b2d37d0de3c3204de86126aadb75c1bb38d11255b41e92"
	;;
	x86_64)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-linux-x64.tar.gz"
		JDK_SHA256="a47dc0962a57b27a0cc00b9f11a53dc3add40c98633ba49a2419b845e4dedf43"
	;;
	*)
		echo "Unkown CPU architecture: `uname -m`"
		exit 1
	;;
esac

# fetch JDK
JDK_TAR_GZ=`basename $JDK_URL`
echo "Download $JDK_URL"
curl -v -L -o "$JDK_TAR_GZ" --retry 5 --cookie "oraclelicense=accept-securebackup-cookie" "$JDK_URL"

# verify archive via SHA-256 checksum
JDK_SHA256_ACTUAL=`openssl dgst -sha256 -hex -r "$JDK_TAR_GZ" | cut -d' ' -f1`
echo "Expected SHA256 checksum: $JDK_SHA256"
echo "Actual SHA256 checksum: $JDK_SHA256_ACTUAL"

if [ "$JDK_SHA256" != "$JDK_SHA256_ACTUAL" ]; then
	echo "ERROR: SHA256 checksum mismatch"
	exit 1
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
