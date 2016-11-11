# Unofficial Java Installer
[![Github Releases](https://img.shields.io/github/downloads/rednoah/java-installer/total.svg)](https://github.com/rednoah/java-installer/releases)
[![GitHub release](https://img.shields.io/github/release/rednoah/java-installer.svg)](http://www.oracle.com/technetwork/java/javase/downloads/index.html)


## Introduction
Synology DSM package for installing the latest Oracle Java binaries on Synology NAS devices.


## Installation on Synology NAS
Add the following __Package Source__ to Synology DSM ► Package Center ► Settings ► Package Sources:

https://app.filebot.net/syno/

On install, the package will download the latest [Oracle Java SE Development Kit](http://www.oracle.com/technetwork/java/javase/downloads/index.html) (180 MB) for your platform. This may take a while.


## Installation on Linux
The [install-jdk.sh](https://github.com/rednoah/java-installer/blob/master/release/install-jdk.sh) shell script should work on any Linux device:

```
# Download the latest JDK into the current directory & link java to /usr/local/bin
curl -O https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jdk.sh
sh -x install-jdk.sh
```


## Installation on Windows
The [install-jre.ps1](https://github.com/rednoah/java-installer/blob/master/release/install-jre.ps1) PowerShell script requires Windows 8 or higher:

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/rednoah/java-installer/master/release/install-jre.ps1 -UseBasicParsing | Invoke-Expression
```

The script uses `7z` to extract the `*.tar.gz` archive, but it will _not_ modify `JAVA_HOME` or the `PATH`.


## Supported Platforms
* Linux ARM v6/v7 Hard Float ABI (`armv7l`)
* Linux ARM v8 Hard Float ABI (`armv8`)
* Linux x86 (`i686`)
* Linux x64 (`x86_64`)
* Windows x86	(`x86`)
* Windows x64	(`AMD64`)
