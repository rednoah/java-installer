ANT := ant -lib lib

build:
	$(ANT) build

spksrc:
	$(ANT) package-source

spk: update
	$(ANT) spk
	$(ANT) package-source

update:
	$(ANT) resolve
	$(ANT) update-jdk
