#!/bin/sh

# Unofficial Java Installer for Oracle Java SE 1.8.0_71
# Example: curl -O https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jdk.sh && sh -x install-jdk.sh

# JDK version identifiers
case `uname -m` in
	armv7l)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u71-b15/jdk-8u71-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="ba3356ab06790288aeb901d3e57297fb71808c5f7b3644f264a139341d74566f"
	;;
	armv8)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u71-b15/jdk-8u71-linux-arm64-vfp-hflt.tar.gz"
		JDK_SHA256="6f554b9f93ecbffd6ca73b313ce0339a2ab398a14b65dd7070d15d9e4a8453d9"
	;;
	i686)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u71-b15/jdk-8u71-linux-i586.tar.gz"
		JDK_SHA256="186f39f6a536ab309dada67d4038a208f02ed6ab4d7eedbe95e0feb9f426733b"
	;;
	x86_64)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u71-b15/jdk-8u71-linux-x64.tar.gz"
		JDK_SHA256="9bdb947fccf31e6ad644b7c1e3c658291facf819e4560a856e4d93bd686e58a2"
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
