ANT := ant -lib lib

syno-repo:
	$(ANT) syno-repo

spk: update
	$(ANT) spk
	$(ANT) syno-repo

qpkg: update
	$(ANT) qpkg

update:
	$(ANT) resolve
	$(ANT) update-ant
