# Unofficial Java Installer


## Introduction

Synology DSM package for installing the latest Oracle Java binaries on Synology NAS devices.


## Installation on Synology DSM
Add the following __Package Source__ to Package Center ► Settings ► Package Sources:

https://raw.githubusercontent.com/rednoah/java-installer/master/spksrc.json

Upon install, the package will download the latest [Oracle Java SE Development Kit](http://www.oracle.com/technetwork/java/javase/downloads/index.html) (180 MB) for your platform. This may take a while.


### Supported Platforms
* Linux ARM v6/v7 Hard Float ABI (armv7l)
* Linux ARM v8 Hard Float ABI (armv8)
* Linux x86 (i686)
* Linux x64 (x86_64)
