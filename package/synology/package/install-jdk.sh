#!/bin/sh

# fetch JDK for this architecture
CPU_ARCH=`uname -m`

case "$CPU_ARCH" in
	armv7l)
		JDK_ARCH="linux-arm32-vfp-hflt"
	;;
	armv8)
		JDK_ARCH="linux-arm64-vfp-hflt"
	;;
	i686)
		JDK_ARCH="linux-i586"
	;;
	x86_64)
		JDK_ARCH="linux-x64"
	;;
	*)
		echo "Unkown CPU architecture: $CPU_ARCH"
		exit 1
	;;
esac

JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-$JDK_ARCH.tar.gz"
JDK_TAR="jdk_$SYNOPKG_PKGVER-$CPU_ARCH.tar.gz"

echo "Download $JDK_URL"
curl -v -L -o "$JDK_TAR" --cookie "oraclelicense=accept-securebackup-cookie" "$JDK_URL"

echo "Extract $JDK_TAR"
tar -v -zxf "$JDK_TAR"

# find latest java executable
JAVA_EXE=`find "$PWD" -name "java" -type f -print0 | xargs -0 ls -Alt1 | head -n 1  | sed -e 's/\s\+/\s /g' | cut -d' ' -f7-`

# link executable into /usr/local/bin
mkdir -p "/usr/local/bin"
ln -s -f "$JAVA_EXE" "/usr/local/bin/java"

# test
echo "Execute $JAVA_EXE -version"
"$JAVA_EXE" -version
