QPKG_NAME := oracle-java
ICON := ../icons/java_72.svg

resize-icons:
	# QPKG ICONS
	convert -verbose $(ICON) -resize 64x64 -gravity center -background transparent -extent 64x64 icons/$(QPKG_NAME).gif
	convert -verbose $(ICON) -resize 64x64 -gravity center -background transparent -extent 64x64 -colorspace gray icons/$(QPKG_NAME)_gray.gif
	convert -verbose $(ICON) -resize 80x80 -gravity center -background transparent -extent 80x80 icons/$(QPKG_NAME)_80.gif

	# REPOSITORY ICONS
	convert -verbose $(ICON) -resize 80x80 -gravity center -background transparent -extent 80x80 icons/$(QPKG_NAME)_80.png
	convert -verbose $(ICON) -resize 100x100 -gravity center -background transparent -extent 100x100 icons/$(QPKG_NAME)_100.png
