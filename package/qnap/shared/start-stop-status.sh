#!/bin/sh
CONF="/etc/config/qpkg.conf"
QPKG_NAME="oracle-java"
QPKG_ROOT=$(/sbin/getcfg $QPKG_NAME Install_Path -f $CONF)


QPKG_LOG="$QPKG_ROOT/install-jdk.log"
SYS_PROFILE="/etc/profile"
COMMENT="# added by Unofficial Java Installer"


case "$1" in
	start)
		ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
		if [ "$ENABLED" != "TRUE" ]; then
			echo "$QPKG_NAME is disabled."
			exit 1
		fi

		JAVA_EXE=$QPKG_ROOT/*/bin/java
		JAVA_BIN=$(dirname $JAVA_EXE)
		JAVA_HOME=$(dirname $JAVA_BIN)

		/bin/ln -sf "$JAVA_EXE" "/usr/bin/java"
		/bin/ln -sf "$JAVA_HOME" "/opt/java"
		;;

	stop)
		rm -rf "/usr/bin/java"
		rm -rf "/opt/java"
		;;

	restart)
		$0 stop
		$0 start
		;;

	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
esac

exit 0
