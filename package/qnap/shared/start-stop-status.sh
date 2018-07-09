#!/bin/sh
CONF="/etc/config/qpkg.conf"
QPKG_NAME="oracle-java"
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

		# find java executable
		JAVA_EXE=`find "$QPKG_ROOT" -name "java" -type f | head -n 1`
		JAVA_BIN=`dirname $JAVA_EXE`
		JAVA_HOME=`dirname $JAVA_BIN`

		# link executable into /usr/local/bin/java
		ln -sf "$JAVA_EXE" "/usr/bin/java"

		# link java home to /usr/local/java
		ln -sf "$JAVA_HOME" "/usr/share/java"

		# make sure that `java` is working
		if [ -x "/usr/bin/java" ]; then
			# display success message
			"/usr/bin/java" -version >> "$QPKG_LOG" 2>&1
		else
			# display error message
			err_log "Ooops, something went wrong... View Log for details... $QPKG_LOG"
		fi

		# add JAVA_HOME to system-wide profile
		if [ `grep -c "$COMMENT" $SYS_PROFILE` == "0" ]; then
			if [ -x "/usr/share/java/bin/java" ]; then
				echo "Add environment variables to $SYS_PROFILE" >> "$QPKG_LOG"

				# add environment variables to /etc/profile
				echo "export JAVA_HOME=/usr/share/java    $COMMENT" >> "$SYS_PROFILE"
				echo "export LANG=en_US.utf8              $COMMENT" >> "$SYS_PROFILE"
			fi
		fi
	;;

	stop)
		# remove symlinks
		rm "/usr/bin/java"
		rm "/usr/share/java"

		# remove /etc/profile additions
		sed -i "/${COMMENT}/d" "$SYS_PROFILE"
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
