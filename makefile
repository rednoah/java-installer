ANT := ant -lib lib


spksrc:
	$(ANT) package-source

spk: update
	$(ANT) spk
	$(ANT) package-source

update:
	$(ANT) resolve
	$(ANT) update-jdk
