#!/bin/sh
CONF="/etc/config/qpkg.conf"
QPKG_NAME="java-installer"
QPKG_ROOT=`/sbin/getcfg $QPKG_NAME Install_Path -f $CONF`


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

		if [ `grep -c "$COMMENT" $SYS_PROFILE` == "0" ]; then
			if [ -x "/usr/local/java/bin/java" ]; then
				echo "Add environment variables to $SYS_PROFILE" | tee -a "$QPKG_LOG"

				# add environment variables to /etc/profile
				echo "export JAVA_HOME=/usr/local/java    $COMMENT" >> "$SYS_PROFILE"
				echo "export LANG=en_US.utf8              $COMMENT" >> "$SYS_PROFILE"
			fi
		fi
		exit 0
	;;

	stop)
		exit 0
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
