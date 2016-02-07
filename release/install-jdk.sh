#!/bin/sh

# Unofficial Java Installer for Oracle Java SE 1.8.0_73
# Example: curl -O https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jdk.sh && sh -x install-jdk.sh

# JDK version identifiers
case `uname -m` in
	armv7l)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="88cdfc96e518cbcf8625d5dde33f0c96b282aae1bc82e8d8e9be8b658fcb4067"
	;;
	armv8)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-arm64-vfp-hflt.tar.gz"
		JDK_SHA256="dc479344c4af6326d59bed31f9b71c223f20b5c2813295cda343d762d88d2641"
	;;
	i686)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-i586.tar.gz"
		JDK_SHA256="3beda1742719400bc493cf118fc3c71697971cec3ae95a2430a337eb4d143dda"
	;;
	x86_64)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u73-b02/jdk-8u73-linux-x64.tar.gz"
		JDK_SHA256="46a8149efaf9d87a147b244e503f1d7791ec8abbc35a5011c99ed909edb2e3e6"
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
