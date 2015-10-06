#!/bin/sh

export JDK_URL="http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-arm32-vfp-hflt.tar.gz"
export JDK_TAR="jdk_$SYNOPKG_PKGVER.tar.gz"

# fetch tarball
curl -v -L -o "$JDK_TAR" --cookie "oraclelicense=accept-securebackup-cookie" "$JDK_URL" 

# extract tarball
tar -v -zxf "$JDK_TAR"

# find latest java executable
export JAVA_EXE=`find "$PWD" -name "java" -type f -print0 | xargs -0 ls -Alt1 | head -n 1  | sed -e 's/\s\+/\s /g' | cut -d' ' -f7-`

# link executable into /usr/local/bin
mkdir -p "/usr/local/bin"
ln -s -f "$JAVA_EXE" "/usr/local/bin/java"
