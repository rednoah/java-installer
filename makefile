ANT := ant -lib lib

update:
	$(ANT) resolve
	$(ANT) update-jdk
	$(ANT) build

pkg:
	$(ANT) clean spk syno-repo spk-dsm6 syno-repo-dsm6 qpkg

clean:
	git reset --hard
	git pull
	git --no-pager log -1
