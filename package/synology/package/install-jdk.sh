#!/bin/sh

# JDK version identifiers
case `uname -m` in
	armv7l)
		JDK_ARCH    = "@{jdk.armv7l}"
		JDK_VERSION = "@{jdk.armv7l.version}"
		JDK_BUILD   = "@{jdk.armv7l.build}"
		JDK_TAR_GZ  = "@{jdk.armv7l.tar.gz}"
		JDK_SHA256  = "@{jdk.armv7l.sha256}"
	;;
	armv8)
		JDK_ARCH    = "@{jdk.armv8}"
		JDK_VERSION = "@{jdk.armv8.version}"
		JDK_BUILD   = "@{jdk.armv8.build}"
		JDK_TAR_GZ  = "@{jdk.armv8.tar.gz}"
		JDK_SHA256  = "@{jdk.armv8.sha256}"
	;;
	i686)
		JDK_ARCH    = "@{jdk.i686}"
		JDK_VERSION = "@{jdk.i686.version}"
		JDK_BUILD   = "@{jdk.i686.build}"
		JDK_TAR_GZ  = "@{jdk.i686.tar.gz}"
		JDK_SHA256  = "@{jdk.i686.sha256}"
	;;
	x86_64)
		JDK_ARCH    = "@{jdk.x86_64}"
		JDK_VERSION = "@{jdk.x86_64.version}"
		JDK_BUILD   = "@{jdk.x86_64.build}"
		JDK_TAR_GZ  = "@{jdk.x86_64.tar.gz}"
		JDK_SHA256  = "@{jdk.x86_64.sha256}"
	;;
	*)
		echo "Unkown CPU architecture: `uname -m`"
		exit 1
	;;
esac



# enter version-specific working directory
mkdir -p "jdk-$JDK_VERSION-$JDK_ARCH"
cd "jdk-$JDK_VERSION-$JDK_ARCH"

# fetch JDK
JDK_URL="http://download.oracle.com/otn-pub/java/jdk/$JDK_VERSION-$JDK_BUILD/$JDK_TAR_GZ"
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
