#!/bin/sh
CONF="/etc/config/qpkg.conf"
QPKG_NAME="@{package}"
QPKG_ROOT=$(/sbin/getcfg $QPKG_NAME Install_Path -f $CONF)


SYMLINK_JAVA="/usr/bin/java"
SYMLINK_JAVA_HOME="/opt/java"


PKG_LOG="$QPKG_ROOT/install-jdk.log"
SYS_PROFILE="/etc/profile"
COMMENT="# added by $QPKG_NAME"


INSTALLER_SCRIPT="get-java.sh"
INSTALLER_FILE="$QPKG_ROOT/$INSTALLER_SCRIPT"
INSTALLER_URL="https://raw.githubusercontent.com/rednoah/java-installer/master/release/$INSTALLER_SCRIPT"

SIGNATURE_FILE="$INSTALLER_FILE.asc"
SIGNATURE_URL="$INSTALLER_URL.asc"

SIGNATURE_GPG_HOME="$QPKG_ROOT/.gnupg"
SIGNATURE_PUBLIC_KEY="$QPKG_ROOT/maintainer.gpg"
SIGNATURE_PUBLIC_KEY_ID="0x4E402EBF7C3C6A71"


case "$1" in
	install)
		curl -L -o "$SIGNATURE_FILE.latest" -z "$SIGNATURE_FILE" "$SIGNATURE_URL"

		# update timestamp
		touch "$SIGNATURE_FILE"

		# check if signature file has changed, since GitHub doesn't support If-Modified-Since HTTP requests
		if cmp "$SIGNATURE_FILE.latest" "$SIGNATURE_FILE"; then
			echo "$(date): NO UPDATE"
			exit 0
		else
			echo "[$(date): AUTO UPDATE"
			mv "$SIGNATURE_FILE.latest" "$SIGNATURE_FILE"
		fi

		# fetch installer
		curl -L -o "$INSTALLER_FILE" -z "$INSTALLER_FILE" "$INSTALLER_URL"

		# verify signature and run installer
		mkdir -p -m 700 "$SIGNATURE_GPG_HOME"

		if gpg --homedir "$SIGNATURE_GPG_HOME" --keyring "$SIGNATURE_PUBLIC_KEY" --trusted-key "$SIGNATURE_PUBLIC_KEY_ID" --status-fd 1 --verify "$SIGNATURE_FILE" "$INSTALLER_FILE" | tail -n 1 | grep "TRUST_ULTIMATE"; then
			cd "$QPKG_ROOT"
			chmod +x "$INSTALLER_FILE"
			"$INSTALLER_FILE" install jdk
		fi
	;;


	start)
		ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
		if [ "$ENABLED" != "TRUE" ]; then
			echo "$QPKG_NAME is disabled."
			exit 1
		fi

		# check for updates once per month
		if [ ! -x "$INSTALLER_FILE" ] || [ $(find "$QPKG_ROOT" -type f -name '*.asc' -maxdepth 1 -mtime +30 | wc -l) -gt 0 ]; then
			$0 install 2>&1 | tee -a "$PKG_LOG"
		fi

		# add additional symlinks in more persistent folders
		JAVA_EXE=$(find $QPKG_ROOT -name java -type f | grep -v /jre/ | sort | tail -n 1)
		JAVA_BIN=$(dirname $JAVA_EXE)
		JAVA_HOME=$(dirname $JAVA_BIN)

		ln -sf "$JAVA_EXE" "$SYMLINK_JAVA"
		ln -sf "$JAVA_HOME" "$SYMLINK_JAVA_HOME"

		# add environment variables to /etc/profile
		if [ `grep -c "$COMMENT" $SYS_PROFILE` == "0" ]; then
			echo "$(date): Add environment variables to /etc/profile" | tee -a "$PKG_LOG"

			echo "export JAVA_HOME=/opt/java          $COMMENT" >> "$SYS_PROFILE"
			echo "export LANG=en_US.utf8              $COMMENT" >> "$SYS_PROFILE"
		fi
	;;


	stop)
		# remove symlinks
		rm "$SYMLINK_JAVA"
		rm "$SYMLINK_JAVA_HOME"

		# remove /etc/profile additions
		sed -i "/${COMMENT}/d" "$SYS_PROFILE"
	;;


	restart)
		$0 stop
		$0 start
	;;


	status)
		if [ -x "$SYMLINK_JAVA" ] && [ -d "$SYMLINK_JAVA_HOME" ]; then
			exit 0
		else
			exit 150 # package is broken and should be reinstalled
		fi
	;;


	log)
		echo "$PKG_LOG"
	;;


	*)
		echo "Usage: $0 {start|stop|restart|status|log}"
		exit 1
	;;
esac


exit 0
