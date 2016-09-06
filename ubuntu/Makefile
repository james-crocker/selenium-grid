# This Makefile builds the builds

export JOB_NAME=Selenium-Grid Packaging
DISTRO = everest
REPO = $(shell echo $${REPO:-/data/repo})

# Source not in Git; fetch for unpacking
# $SRC_SSH_USER must be set!
SRC_HOST=hancock.sc.steeleye.com
SRC_PATH_ROOT=/filepile/software/selenium-grid-sources
SRC_PATH_LINUX=$(SRC_PATH_ROOT)/linux
SRC_PATH_COMMON=$(SRC_PATH_ROOT)/common
SRC_TMP_DIR=tmpsrc
RM = /bin/rm

export SELENIUM_SERVER_SRC=selenium-server-standalone-3.0.0-beta3.jar
export DRIVER_CHROME_SRC=chromedriver_2.23_linux64.zip
export DRIVER_GECKO_SRC=geckodriver-v0.10.0-linux64.tar.gz
export SELENIUM_SERVER_HUB=selenium-server-hub.jar
export SELENIUM_SERVER_NODE=selenium-server-node.jar
export CHROMEDRIVER=chromedriver
export GECKODRIVER=geckodriver

PKG_SEL_HUB=selenium-hub
PKG_SEL_NODE=selenium-node
PKG_SEL_NODE_HEADLESS=selenium-node-headless
PKG_SEL_XVFB=selenium-xvfb

#DPKG_BUILDPACKAGE=dpkg-buildpackage -us -uc -b -tc
DPKG_BUILDPACKAGE=dpkg-buildpackage -us -uc -b

ALERT='!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

.PHONY: clean

all: allclean local sign repo

local: getsource hub node node-headless xvfb

hub: getsource
	cd $(PKG_SEL_HUB) && $(DPKG_BUILDPACKAGE)

node: getsource
	cd $(PKG_SEL_NODE) && $(DPKG_BUILDPACKAGE)

node-headless: getsource
	cd $(PKG_SEL_NODE)-headless && $(DPKG_BUILDPACKAGE)

xvfb: getsource
	cd $(PKG_SEL_XVFB) && $(DPKG_BUILDPACKAGE)

sign:
	dpkg-sig -s builder $(PKG_SEL_HUB)_*.deb
	dpkg-sig -s builder $(PKG_SEL_NODE)_*.deb
	dpkg-sig -s builder $(PKG_SEL_NODE_HEADLESS)_*.deb
	dpkg-sig -s builder $(PKG_SEL_XVFB)_*.deb

repo:
	reprepro -Vb $(REPO) includedeb $(DISTRO) $(PKG_SEL_HUB)_*.deb
	reprepro -Vb $(REPO) includedeb $(DISTRO) $(PKG_SEL_NODE)_*.deb
	reprepro -Vb $(REPO) includedeb $(DISTRO) $(PKG_SEL_NODE_HEADLESS)_*.deb
	reprepro -Vb $(REPO) includedeb $(DISTRO) $(PKG_SEL_XVFB)_*.deb
	apt-ftparchive release $(REPO) ; \
	for f in `find $(REPO) -name Release` ; \
	do \
		d=`dirname $$f` ; \
		rm -f $$d/InRelease ; \
		gpg --clearsign -o $$d/InRelease $$d/Release ; \
		rm -f $$d/Release.gpg ; \
		gpg -abs -o $$d/Release.gpg $$d/Release ; \
	done


# get needed source material to include in packages; stored elsewhere outside of Git.
getsource:
	@if [ -z $(SRC_SSH_USER) ]; \
	then \
		echo $(ALERT); \
		echo "\nERROR: SRC_SSH_USER unset; must be set to fetch sources from '$(SRC_HOST)'\n"; \
		echo $(ALERT); \
		exit 1; \
	fi
	@if [ -d $(SRC_TMP_DIR) ]; \
	then \
		echo $(ALERT); \
		echo "\nWARNING: '$(SRC_TMP_DIR)' exists and may contain stale data. Consider 'make clean'; continuing\n"; \
		echo $(ALERT); \
	else \
		mkdir ./$(SRC_TMP_DIR); \
		cd ./$(SRC_TMP_DIR); \
		scp  $(SRC_SSH_USER)@$(SRC_HOST):$(SRC_PATH_LINUX)/$(DRIVER_CHROME_SRC) .; \
		unzip $(DRIVER_CHROME_SRC); \
		scp  $(SRC_SSH_USER)@$(SRC_HOST):$(SRC_PATH_LINUX)/$(DRIVER_GECKO_SRC) .; \
		tar xvfpz $(DRIVER_GECKO_SRC); \
		scp  $(SRC_SSH_USER)@$(SRC_HOST):$(SRC_PATH_COMMON)/$(SELENIUM_SERVER_SRC) $(SELENIUM_SERVER_HUB); \
		cp $(SELENIUM_SERVER_HUB) $(SELENIUM_SERVER_NODE); \
		chmod 755 $(SELENIUM_SERVER_HUB) $(SELENIUM_SERVER_NODE) $(CHROMEDRIVER) $(GECKODRIVER); \
	fi

clean:
	$(RM) -f *.deb *.changes
	cd $(PKG_SEL_HUB) && make -f debian/rules clean
	cd $(PKG_SEL_NODE) && make -f debian/rules clean
	cd $(PKG_SEL_NODE_HEADLESS) && make -f debian/rules clean
	cd $(PKG_SEL_XVFB) && make -f debian/rules clean

allclean: clean
	$(RM) -rf $(SRC_TMP_DIR)

