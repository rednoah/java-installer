#!/bin/sh

# Unofficial Java Installer for Oracle Java SE 1.8.0_101
# Example: curl -O https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jdk.sh && sh -x install-jdk.sh

# JDK version identifiers
case `uname -m` in
	armv7l)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-arm32-vfp-hflt.tar.gz"
		JDK_SHA256="9819bd28af551589c8ea599c5b8b5cdf1aa86dacc9a75c31dd611bda27ae38a4"
	;;
	armv8)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-arm64-vfp-hflt.tar.gz"
		JDK_SHA256="795df50a2991e84866ccd251111cfa1cf72d1859aa77d4cc1a8fa2419d254bcf"
	;;
	i686)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-i586.tar.gz"
		JDK_SHA256="b11212ef06235296cad2f9b80a22f2d853a2d2f66ce55b993eb686e5a2da365d"
	;;
	x86_64)
		JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.tar.gz"
		JDK_SHA256="467f323ba38df2b87311a7818bcbf60fe0feb2139c455dfa0e08ba7ed8581328"
	;;
	*)
		echo "CPU architecture not supported: `uname -m`"
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
