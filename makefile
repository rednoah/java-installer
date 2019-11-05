ANT := ant -lib lib

update:
	$(ANT) resolve
	$(ANT) update-jdk
	$(ANT) build

pkg:
	$(ANT) clean spk syno-repo qpkg
