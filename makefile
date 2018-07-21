ANT := ant -lib lib

update:
	$(ANT) clean resolve
	$(ANT) update-jdk
	$(ANT) build

syno-repo:
	$(ANT) syno-repo

spk:
	$(ANT) spk
	$(ANT) syno-repo

qpkg:
	$(ANT) qpkg
