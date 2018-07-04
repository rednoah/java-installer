ANT := ant -lib lib

spksrc:
	$(ANT) syno-repo

spk: update
	$(ANT) spk
	$(ANT) syno-repo

qpkg: update
	$(ANT) qpkg
	$(ANT) qnap-repo

update:
	$(ANT) resolve
	$(ANT) update-ant
