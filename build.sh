#/bin/sh
ant resolve && ant update-jdk -lib "lib" && ant spk package-source -lib "lib"
