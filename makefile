ANT := ant -lib lib

update:
	$(ANT) resolve
	$(ANT) update-jdk
	$(ANT) build

spk:
	$(ANT) clean spk syno-repo

qpkg:
	$(ANT) clean qpkg
