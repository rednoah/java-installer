#!/bin/sh

# Unofficial Java Installer for Oracle Java SE 1.8.0_91
# Example: curl -O https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jdk.sh && sh -x install-jdk.sh

# JDK version identifiers
case `uname -m` in
	armv7l)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="79dda1dec6ccd7130b5204e75d1a8300e5b02c18f70888697f51764a777e5339"
	;;
	armv8)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-arm64-vfp-hflt.tar.gz"
		JDK_SHA256="3dededc2e31bfda0a129b1df394e37078f339aa99e82e56d35cabff28ccfeb3b"
	;;
	i686)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-i586.tar.gz"
		JDK_SHA256="5ecd05b5e566cbe688fc1e3159f04004ccad14d4faa3f50d15ffba1d50b4cd52"
	;;
	x86_64)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.tar.gz"
		JDK_SHA256="6f9b516addfc22907787896517e400a62f35e0de4a7b4d864b26b61dbe1b7552"
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
