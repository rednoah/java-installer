# Java Installer
[![Github Releases](https://img.shields.io/github/downloads/rednoah/java-installer/total.svg)](https://github.com/rednoah/java-installer/releases)
[![GitHub release](https://img.shields.io/github/release/rednoah/java-installer.svg)](https://jdk.java.net/)


## Introduction
This repository maintains packages for installing the latest OpenJDK binaries on Synology NAS and QNAP NAS.


## Installation on Synology DSM
Add the following __Package Source__ to Synology DSM ► Package Center ► Settings ► Package Sources:
```
https://get.filebot.net/syno/
```


## Installation on QNAP QTS
Add the following __App Repository__ to QNAP QTS ► App Center ► Settings ► App Repository ► Add:
```
https://get.filebot.net/qnap/index.xml
```


## Installation on Linux
The [get-java.sh](https://github.com/rednoah/java-installer/blob/latest/release/get-java.sh) shell script should work on any Linux device:

```bash
# Download the latest JDK into the current directory & link java to /usr/local/bin
curl -O https://raw.githubusercontent.com/rednoah/java-installer/latest/release/get-java.sh
sh get-java.sh install
```


## Installation on Windows
The [get-java.ps1](https://github.com/rednoah/java-installer/blob/latest/release/get-java.ps1) PowerShell script requires Windows 8 or higher:

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/rednoah/java-installer/latest/release/get-java.ps1 -OutFile get-java.ps1 -UseBasicParsing
powershell -File get-java.ps1 install
```

The script uses `7z` to extract the `*.tar.gz` archive, but it will _not_ modify `JAVA_HOME` or the `PATH`.


## Supported Platforms
* Linux (`x86_64`, `aarch64`, `armv7l`, `i686`, `ppc64le`)
* Windows (`x86_64`, `x86`)
* macOS (`x86_64`, `arm64`)


## Package Sources
* [Adoptium](https://adoptium.net/)
* [Liberica](https://bell-sw.com/pages/downloads/)
* [Gluon](https://gluonhq.com/products/javafx/)
