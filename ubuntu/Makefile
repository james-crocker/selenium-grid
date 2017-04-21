# This Makefile builds the builds

export JOB_NAME=Selenium-Grid Packaging
DISTRO = everest
REPO = $(shell echo $${REPO:-/data/repo})

RM = /bin/rm

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Make sure versions match packages most recent changelog entry
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# debuild doesn't use the full change log version which would read
# 1.0.0+1SNAPSHOT201702091400-1ubuntu0
export LP_HUB_VER=1.0.5
export LP_NODE_VER=1.0.5
export LP_NODE_HEADLESS_VER=1.0.5
export LP_XVFB_VER=1.0.5
export LP_UBUNTU_VER=-0ubuntu1

export SELENIUM_SERVER_VER=3.4.0
export CHROMEDRIVER_VER=2.29
export GECKODRIVER_VER=0.15.0
export CHROMEDRIVER_NAME=chromedriver
export GECKODRIVER_NAME=geckodriver

export SELENIUM_SERVER_SRC=http://selenium-release.storage.googleapis.com/3.4/selenium-server-standalone-$(SELENIUM_SERVER_VER).jar
export CHROMEDRIVER_SRC=https://chromedriver.storage.googleapis.com/$(CHROMEDRIVER_VER)/chromedriver_linux64.zip
export GECKODRIVER_SRC=https://github.com/mozilla/geckodriver/releases/download/v$(GECKODRIVER_VER)/geckodriver-v$(GECKODRIVER_VER)-linux64.tar.gz

export CHROMEDRIVER_ARCHIVE=$(CHROMEDRIVER_NAME)-$(CHROMEDRIVER_VER).zip
export GECKODRIVER_ARCHIVE=$(GECKODRIVER_NAME)-$(GECKODRIVER_VER).tar.gz

export JAR_SUFFIX=.jar
export SELENIUM_SERVER_HUB_BIN=selenium-hub-$(SELENIUM_SERVER_VER)$(JAR_SUFFIX)
export SELENIUM_SERVER_NODE_BIN=selenium-node-$(SELENIUM_SERVER_VER)$(JAR_SUFFIX)
export CHROMEDRIVER_BIN=$(CHROMEDRIVER_NAME)-$(CHROMEDRIVER_VER)
export GECKODRIVER_BIN=$(GECKODRIVER_NAME)-$(GECKODRIVER_VER)

PKG_SEL_HUB=selenium-hub
PKG_SEL_NODE=selenium-node
PKG_SEL_NODE_HEADLESS=selenium-node-headless
PKG_SEL_XVFB=selenium-xvfb
PKG_SRC=src

PKG_SEL_HUB_SRC=$(PKG_SEL_HUB)/$(PKG_SRC)
PKG_SEL_NODE_SRC=$(PKG_SEL_NODE)/$(PKG_SRC)
PKG_SEL_NODE_HEADLESS_SRC=$(PKG_SEL_NODE_HEADLESS)/$(PKG_SRC)

PPA_ORIG_ARCHIVE=.orig.tar.gz
PPA_UPLOAD_LOG=.ppa.upload
PPA_TARGET=ppa:siostechcorp/selenium-grid
PPA_SOURCE_CHANGES=_source.changes

PPA_SEL_HUB=$(PKG_SEL_HUB)_$(LP_HUB_VER)
PPA_SEL_NODE=$(PKG_SEL_NODE)_$(LP_NODE_VER)
PPA_SEL_NODE_HEADLESS=$(PKG_SEL_NODE_HEADLESS)_$(LP_NODE_HEADLESS_VER)
PPA_SEL_XVFB=$(PKG_SEL_XVFB)_$(LP_XVFB_VER)

SEL_HUB_INSTALL=$(PKG_SEL_HUB)/debian/$(PKG_SEL_HUB).install
SEL_HUB_LINKS=$(PKG_SEL_HUB)/debian/$(PKG_SEL_HUB).links
SEL_NODE_INSTALL=$(PKG_SEL_NODE)/debian/$(PKG_SEL_NODE).install
SEL_NODE_LINKS=$(PKG_SEL_NODE)/debian/$(PKG_SEL_NODE).links
SEL_NODE_HEADLESS_INSTALL=$(PKG_SEL_NODE_HEADLESS)/debian/$(PKG_SEL_NODE_HEADLESS).install
SEL_NODE_HEADLESS_LINKS=$(PKG_SEL_NODE_HEADLESS)/debian/$(PKG_SEL_NODE_HEADLESS).links

# Make stanzas supporting in house repo build and launchpad ppa packaging
# Launchpad stanzas are launchpad and *-lp
# Launchpad signing is with the PGP Key CE35DE0E (SIOS Technology Corp.) <support@us.sios.com>

# In house build bin
#DPKG=dpkg-buildpackage -us -uc -b -tc
DPKG=dpkg-buildpackage -us -uc -b
# Launchpad build bin
DEBUILD=debuild -S

ALERT='!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

all-local: allclean local sign repo

local: hub node node-headless xvfb

all-launchpad: allclean launchpad launchpad-upload

launchpad: hub-lp node-lp node-headless-lp xvfb-lp

launchpad-upload: hub-lp-upload node-lp-upload node-headless-lp-upload xvfb-lp-upload

hub: get_hub_source hub-deb-files
	cd $(PKG_SEL_HUB) && $(DPKG)

hub-lp: get_hub_source hub-deb-files tar_hub
	cd $(PKG_SEL_HUB) && $(DEBUILD)

hub-deb-files:
	echo src/$(SELENIUM_SERVER_HUB_BIN) usr/share/java > $(SEL_HUB_INSTALL)
	echo selenium-hubConfig.json etc/default >> $(SEL_HUB_INSTALL)
	echo usr/share/java/$(SELENIUM_SERVER_HUB_BIN) usr/share/java/selenium-hub.jar > $(SEL_HUB_LINKS)
	cp $(SEL_HUB_LINKS) /tmp/.
	cp $(SEL_HUB_INSTALL) /tmp/.

hub-lp-upload:
	dput $(PPA_TARGET) $(PPA_SEL_HUB)$(LP_UBUNTU_VER)$(PPA_SOURCE_CHANGES)

node: get_node_source node-deb-files
	cd $(PKG_SEL_NODE) && $(DPKG)

node-lp: get_node_source node-deb-files tar_node
	cd $(PKG_SEL_NODE) && $(DEBUILD)

node-deb-files:
	echo src/$(SELENIUM_SERVER_NODE_BIN) usr/share/java > $(SEL_NODE_INSTALL)
	echo src/$(CHROMEDRIVER_BIN) usr/bin >> $(SEL_NODE_INSTALL)
	echo src/$(GECKODRIVER_BIN) usr/bin >> $(SEL_NODE_INSTALL)
	echo selenium-nodeConfig.json etc/default >> $(SEL_NODE_INSTALL)
	echo usr/share/java/$(SELENIUM_SERVER_NODE_BIN) usr/share/java/selenium-node.jar > $(SEL_NODE_LINKS)
	echo usr/bin/$(CHROMEDRIVER_BIN) usr/bin/chromedriver >> $(SEL_NODE_LINKS)
	echo usr/bin/$(GECKODRIVER_BIN) usr/bin/geckodriver >> $(SEL_NODE_LINKS)

node-lp-upload:
	dput $(PPA_TARGET) $(PPA_SEL_NODE)$(LP_UBUNTU_VER)$(PPA_SOURCE_CHANGES)

node-headless: get_node_headless_source node-headless-deb-files
	cd $(PKG_SEL_NODE_HEADLESS) && $(DPKG)

node-headless-lp: get_node_headless_source node-headless-deb-files tar_node_headless
	cd $(PKG_SEL_NODE_HEADLESS) && $(DEBUILD)

node-headless-deb-files:
	echo src/$(SELENIUM_SERVER_NODE_BIN) usr/share/java > $(SEL_NODE_HEADLESS_INSTALL)
	echo src/$(CHROMEDRIVER_BIN) usr/bin >> $(SEL_NODE_HEADLESS_INSTALL)
	echo src/$(GECKODRIVER_BIN) usr/bin >> $(SEL_NODE_HEADLESS_INSTALL)
	echo selenium-nodeConfig.json etc/default >> $(SEL_NODE_HEADLESS_INSTALL)
	echo usr/share/java/$(SELENIUM_SERVER_NODE_BIN) usr/share/java/selenium-node.jar > $(SEL_NODE_HEADLESS_LINKS)
	echo usr/bin/$(CHROMEDRIVER_BIN) usr/bin/chromedriver >> $(SEL_NODE_HEADLESS_LINKS)
	echo usr/bin/$(GECKODRIVER_BIN) usr/bin/geckodriver >> $(SEL_NODE_HEADLESS_LINKS)

node-headless-lp-upload:
	dput $(PPA_TARGET) $(PPA_SEL_NODE_HEADLESS)$(LP_UBUNTU_VER)$(PPA_SOURCE_CHANGES)

xvfb:
	cd $(PKG_SEL_XVFB) && $(DPKG)

xvfb-lp: tar_xvfb
	cd $(PKG_SEL_XVFB) && $(DEBUILD)

xvfb-lp-upload:
	dput $(PPA_TARGET) $(PPA_SEL_XVFB)$(LP_UBUNTU_VER)$(PPA_SOURCE_CHANGES)

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
get_hub_source:
	@if [ -d $(PKG_SEL_HUB_SRC) ]; \
	then \
		echo $(ALERT); \
		echo "\nWARNING: '$(PKG_SEL_HUB_SRC)' exists and may contain stale data. Consider 'make clean'; continuing\n"; \
		echo $(ALERT); \
	else \
		mkdir ./$(PKG_SEL_HUB_SRC); \
		cd ./$(PKG_SEL_HUB_SRC); \
		wget -t 5 $(SELENIUM_SERVER_SRC) -O $(SELENIUM_SERVER_HUB_BIN); \
		chmod 644 $(SELENIUM_SERVER_HUB_BIN); \
	fi

get_node_source:
	@if [ -d $(PKG_SEL_NODE_SRC) ]; \
	then \
		echo $(ALERT); \
		echo "\nWARNING: '$(PKG_SEL_NODE_SRC)' exists and may contain stale data. Consider 'make clean'; continuing\n"; \
		echo $(ALERT); \
	else \
		mkdir ./$(PKG_SEL_NODE_SRC); \
		cd ./$(PKG_SEL_NODE_SRC); \
		wget  -t 5 $(CHROMEDRIVER_SRC) -O $(CHROMEDRIVER_ARCHIVE); \
		unzip $(CHROMEDRIVER_ARCHIVE); \
		mv $(CHROMEDRIVER_NAME) $(CHROMEDRIVER_BIN); \
		wget -t 5 $(GECKODRIVER_SRC) -O $(GECKODRIVER_ARCHIVE); \
		tar xvfpz $(GECKODRIVER_ARCHIVE); \
		mv $(GECKODRIVER_NAME) $(GECKODRIVER_BIN); \
		wget -t 5 $(SELENIUM_SERVER_SRC) -O $(SELENIUM_SERVER_NODE_BIN); \
		chmod 644 $(SELENIUM_SERVER_NODE_BIN); \
		chmod 755 $(CHROMEDRIVER_BIN) $(GECKODRIVER_BIN); \
	fi

get_node_headless_source:
	@if [ -d $(PKG_SEL_NODE_HEADLESS_SRC) ]; \
	then \
		echo $(ALERT); \
		echo "\nWARNING: '$(PKG_SEL_NODE_HEADLESS_SRC)' exists and may contain stale data. Consider 'make clean'; continuing\n"; \
		echo $(ALERT); \
	else \
		mkdir ./$(PKG_SEL_NODE_HEADLESS_SRC); \
		cd ./$(PKG_SEL_NODE_HEADLESS_SRC); \
		wget  -t 5 $(CHROMEDRIVER_SRC) -O $(CHROMEDRIVER_ARCHIVE); \
		unzip $(CHROMEDRIVER_ARCHIVE); \
		mv $(CHROMEDRIVER_NAME) $(CHROMEDRIVER_BIN); \
		wget -t 5 $(GECKODRIVER_SRC) -O $(GECKODRIVER_ARCHIVE); \
		tar xvfpz $(GECKODRIVER_ARCHIVE); \
		mv $(GECKODRIVER_NAME) $(GECKODRIVER_BIN); \
		wget -t 5 $(SELENIUM_SERVER_SRC) -O $(SELENIUM_SERVER_NODE_BIN); \
		chmod 644 $(SELENIUM_SERVER_NODE_BIN); \
		chmod 755 $(CHROMEDRIVER_BIN) $(GECKODRIVER_BIN); \
	fi

tar_hub:
	tar cvfzp $(PPA_SEL_HUB)$(PPA_ORIG_ARCHIVE) $(PKG_SEL_HUB)

tar_node:
	tar cvfzp $(PPA_SEL_NODE)$(PPA_ORIG_ARCHIVE) $(PKG_SEL_NODE)

tar_node_headless:
	tar cvfzp $(PPA_SEL_NODE_HEADLESS)$(PPA_ORIG_ARCHIVE) $(PKG_SEL_NODE_HEADLESS)

tar_xvfb:
	tar cvfzp $(PPA_SEL_XVFB)$(PPA_ORIG_ARCHIVE) $(PKG_SEL_XVFB)

clean:
	$(RM) -f *.deb *.changes *.build *.dsc *.xz
	$(RM) -rf build-area
	$(RM) -f *$(PPA_ORIG_ARCHIVE)
	$(RM) -f *$(PPA_UPLOAD_LOG)
	$(RM) -f $(SEL_HUB_INSTALL)
	$(RM) -f $(SEL_HUB_LINKS)
	$(RM) -f $(SEL_NODE_INSTALL)
	$(RM) -f $(SEL_NODE_LINKS)
	$(RM) -f $(SEL_NODE_HEADLESS_INSTALL)
	$(RM) -f $(SEL_NODE_HEADLESS_LINKS)
	cd $(PKG_SEL_HUB) && make -f debian/rules clean
	cd $(PKG_SEL_NODE) && make -f debian/rules clean
	cd $(PKG_SEL_NODE_HEADLESS) && make -f debian/rules clean
	cd $(PKG_SEL_XVFB) && make -f debian/rules clean

allclean: clean
	$(RM) -rf $(PKG_SEL_HUB_SRC)
	$(RM) -rf $(PKG_SEL_NODE_SRC)
	$(RM) -rf $(PKG_SEL_NODE_HEADLESS_SRC)

