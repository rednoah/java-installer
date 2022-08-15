ANT := ant -lib lib

update:
	$(ANT) update-jdk
	$(ANT) build

pkg:
	$(ANT) clean spk syno-repo spk-dsm6 syno-repo-dsm6 qpkg

resolve:
	ant resolve

clean:
	git reset --hard
	git pull
	git --no-pager log -1
