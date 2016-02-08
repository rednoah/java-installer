# Unofficial Java Installer

## Introduction
Synology DSM package for installing the latest Oracle Java binaries on Synology NAS devices.

## Installation on Synology NAS
Add the following __Package Source__ to Synology DSM ► Package Center ► Settings ► Package Sources:

https://app.filebot.net/syno/

On install, the package will download the latest [Oracle Java SE Development Kit](http://www.oracle.com/technetwork/java/javase/downloads/index.html) (180 MB) for your platform. This may take a while.

## Installation via SSH
The [install-jdk.sh](https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jdk.sh) shell script should work on any Linux device:

```
# Download the latest JDK into the current directory & link java to /usr/local/bin
curl -O https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jdk.sh
sh -x install-jdk.sh
```

## Supported Platforms
* Linux ARM v6/v7 Hard Float ABI (`armv7l`)
* Linux ARM v8 Hard Float ABI (`armv8`)
* Linux x86 (`i686`)
* Linux x64 (`x86_64`)
