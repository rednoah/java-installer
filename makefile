ANT := ant -lib lib

update:
	$(ANT) resolve
	$(ANT) update-jdk
	$(ANT) build

pkg:
	$(ANT) clean spk syno-repo qpkg

clean:
	git reset --hard
	git pull
	git --no-pager log -1
