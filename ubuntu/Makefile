# This Makefile builds the ubuntu debs locally or in Launchpad (remote)

JOB_NAME=Selenium-Grid Packaging
DISTRO = everest

PKG_SEL_HUB=selenium-hub
PKG_SEL_NODE=selenium-node
PKG_SEL_NODE_HEADLESS=selenium-node-headless
PKG_SEL_XVFB=selenium-xvfb
PKG_SRC=src

PKG_SEL_HUB_SRC=./$(PKG_SEL_HUB)/$(PKG_SRC)
PKG_SEL_NODE_SRC=./$(PKG_SEL_NODE)/$(PKG_SRC)
PKG_SEL_NODE_HEADLESS_SRC=./$(PKG_SEL_NODE_HEADLESS)/$(PKG_SRC)

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

.PHONY: chk clean tar-hub tar-node tar-node-headless tar-xvfb hub-deb-files \
hub-lp-upload node-deb-files node-headless-deb-files node-headless-lp-upload \
xvfb xvfb-lp sign repo get-hub-source get-node-source get-node-headless_source \
hub hub-lp node node-lp node-headless node-headless-lp remote remote-upload \
all-local local all-remote

chk:
	@if [ -z $(TMPDIR) ]; \
	then \
		echo "Must be called from parent ../Makefile"; \
		exit 1; \
	fi

clean:
	rm -f *.deb *.changes *.build *.dsc *.xz
	rm -rf build-area
	rm -f *$(PPA_ORIG_ARCHIVE)
	rm -f *$(PPA_UPLOAD_LOG)
	rm -f $(SEL_HUB_INSTALL)
	rm -f $(SEL_HUB_LINKS)
	rm -f $(SEL_NODE_INSTALL)
	rm -f $(SEL_NODE_LINKS)
	rm -f $(SEL_NODE_HEADLESS_INSTALL)
	rm -f $(SEL_NODE_HEADLESS_LINKS)
	cd $(PKG_SEL_HUB) && make -f debian/rules clean
	-rm -rf $(PKG_SEL_HUB_SRC)
	cd $(PKG_SEL_NODE) && make -f debian/rules clean
	-rm -rf $(PKG_SEL_NODE_SRC)
	cd $(PKG_SEL_NODE_HEADLESS) && make -f debian/rules clean
	-rm -rf $(PKG_SEL_NODE_HEADLESS_SRC)
	cd $(PKG_SEL_XVFB) && make -f debian/rules clean
	-rm -f ../$(PKG_SEL_HUB)_*.deb
	-rm -f ../$(PKG_SEL_NODE)_*.deb
	-rm -f ../$(PKG_SEL_NODE_HEADLESS)_*.deb
	-rm -f ../$(PKG_SEL_XVFB)_*.deb
		
tar-hub:
	tar cvfzp $(PPA_SEL_HUB)$(PPA_ORIG_ARCHIVE) $(PKG_SEL_HUB)

tar-node:
	tar cvfzp $(PPA_SEL_NODE)$(PPA_ORIG_ARCHIVE) $(PKG_SEL_NODE)

tar-node-headless:
	tar cvfzp $(PPA_SEL_NODE_HEADLESS)$(PPA_ORIG_ARCHIVE) $(PKG_SEL_NODE_HEADLESS)

tar-xvfb:
	tar cvfzp $(PPA_SEL_XVFB)$(PPA_ORIG_ARCHIVE) $(PKG_SEL_XVFB)
	
hub-deb-files:
	echo src/$(SELENIUM_SERVER_HUB_JAR) usr/share/java > $(SEL_HUB_INSTALL)
	echo selenium-hubConfig.json etc/default >> $(SEL_HUB_INSTALL)
	echo usr/share/java/$(SELENIUM_SERVER_HUB_JAR) usr/share/java/selenium-hub.jar > $(SEL_HUB_LINKS)
	cp $(SEL_HUB_LINKS) /tmp/.
	cp $(SEL_HUB_INSTALL) /tmp/.

hub-lp-upload:
	dput $(PPA_TARGET) $(PPA_SEL_HUB)$(LP_UBUNTU_VER)$(PPA_SOURCE_CHANGES)

node-deb-files:
	echo src/$(SELENIUM_SERVER_NODE_JAR) usr/share/java > $(SEL_NODE_INSTALL)
	echo src/$(CHROMEDRIVER_BIN) usr/bin >> $(SEL_NODE_INSTALL)
	echo src/$(GECKODRIVER_BIN) usr/bin >> $(SEL_NODE_INSTALL)
	echo selenium-nodeConfig.json etc/default >> $(SEL_NODE_INSTALL)
	echo usr/share/java/$(SELENIUM_SERVER_NODE_JAR) usr/share/java/selenium-node.jar > $(SEL_NODE_LINKS)
	echo usr/bin/$(CHROMEDRIVER_BIN) usr/bin/chromedriver >> $(SEL_NODE_LINKS)
	echo usr/bin/$(GECKODRIVER_BIN) usr/bin/geckodriver >> $(SEL_NODE_LINKS)

node-lp-upload:
	dput $(PPA_TARGET) $(PPA_SEL_NODE)$(LP_UBUNTU_VER)$(PPA_SOURCE_CHANGES)

node-headless-deb-files:
	echo src/$(SELENIUM_SERVER_NODE_JAR) usr/share/java > $(SEL_NODE_HEADLESS_INSTALL)
	echo src/$(CHROMEDRIVER_BIN) usr/bin >> $(SEL_NODE_HEADLESS_INSTALL)
	echo src/$(GECKODRIVER_BIN) usr/bin >> $(SEL_NODE_HEADLESS_INSTALL)
	echo selenium-nodeConfig.json etc/default >> $(SEL_NODE_HEADLESS_INSTALL)
	echo usr/share/java/$(SELENIUM_SERVER_NODE_JAR) usr/share/java/selenium-node.jar > $(SEL_NODE_HEADLESS_LINKS)
	echo usr/bin/$(CHROMEDRIVER_BIN) usr/bin/chromedriver >> $(SEL_NODE_HEADLESS_LINKS)
	echo usr/bin/$(GECKODRIVER_BIN) usr/bin/geckodriver >> $(SEL_NODE_HEADLESS_LINKS)

node-headless-lp-upload:
	dput $(PPA_TARGET) $(PPA_SEL_NODE_HEADLESS)$(LP_UBUNTU_VER)$(PPA_SOURCE_CHANGES)

xvfb:
	cd $(PKG_SEL_XVFB) && $(DPKG)

xvfb-lp: tar-xvfb
	cd $(PKG_SEL_XVFB) && $(DEBUILD)

xvfb-lp-upload:
	dput $(PPA_TARGET) $(PPA_SEL_XVFB)$(LP_UBUNTU_VER)$(PPA_SOURCE_CHANGES)

sign:
	dpkg-sig -s builder $(PKG_SEL_HUB)_*.deb
	dpkg-sig -s builder $(PKG_SEL_NODE)_*.deb
	dpkg-sig -s builder $(PKG_SEL_NODE_HEADLESS)_*.deb
	dpkg-sig -s builder $(PKG_SEL_XVFB)_*.deb

# get needed source material to include in packages; stored elsewhere outside of Git.
get-hub-source: chk
	@if [ -d $(PKG_SEL_HUB_SRC) ]; \
	then \
		echo $(ALERT); \
		echo "\nWARNING: [$(PKG_SEL_HUB_SRC)] exists and may contain stale data. \
Consider 'make clean'\n"; \
		echo $(ALERT); \
	else \
		mkdir $(PKG_SEL_HUB_SRC); \
		cd $(PKG_SEL_HUB_SRC); \
		cp $(TMPDIR)/$(SELENIUM_NAME) $(SELENIUM_SERVER_HUB_JAR); \
		chmod 644 $(SELENIUM_SERVER_HUB_JAR); \
	fi

get-node-source: chk
	@if [ -d $(PKG_SEL_NODE_SRC) ]; \
	then \
		echo $(ALERT); \
		echo "\nWARNING: [$(PKG_SEL_NODE_SRC)] exists and may contain stale data. \
Consider 'make clean'\n"; \
		echo $(ALERT); \
	else \
		mkdir $(PKG_SEL_NODE_SRC); \
		cd $(PKG_SEL_NODE_SRC); \
		cp $(TMPDIR)/$(SELENIUM_NAME) $(SELENIUM_SERVER_NODE_JAR); \
		cp $(TMPDIR)/$(CHROMEDRIVER_BIN) $(CHROMEDRIVER_BIN); \
		cp $(TMPDIR)/$(GECKODRIVER_BIN) $(GECKODRIVER_BIN); \
		chmod 644 $(SELENIUM_SERVER_NODE_JAR); \
		chmod 755 $(CHROMEDRIVER_BIN) $(GECKODRIVER_BIN); \
	fi

get-node-headless_source: chk
	@if [ -d $(PKG_SEL_NODE_HEADLESS_SRC) ]; \
	then \
		echo $(ALERT); \
		echo "\nWARNING: [$(PKG_SEL_NODE_HEADLESS_SRC)] exists and may contain \
stale data. Consider 'make clean'\n"; \
		echo $(ALERT); \
	else \
		mkdir $(PKG_SEL_NODE_HEADLESS_SRC); \
		cd $(PKG_SEL_NODE_HEADLESS_SRC); \
		cp $(TMPDIR)/$(SELENIUM_NAME) $(SELENIUM_SERVER_NODE_JAR); \
		cp $(TMPDIR)/$(CHROMEDRIVER_BIN) $(CHROMEDRIVER_BIN); \
		cp $(TMPDIR)/$(GECKODRIVER_BIN) $(GECKODRIVER_BIN); \
		chmod 644 $(SELENIUM_SERVER_NODE_JAR); \
		chmod 755 $(CHROMEDRIVER_BIN) $(GECKODRIVER_BIN); \
	fi

hub: get-hub-source hub-deb-files
	cd $(PKG_SEL_HUB) && $(DPKG)

hub-lp: get-hub-source hub-deb-files tar-hub
	cd $(PKG_SEL_HUB) && $(DEBUILD)
	
node: get-node-source node-deb-files
	cd $(PKG_SEL_NODE) && $(DPKG)

node-lp: get-node-source node-deb-files tar-node
	cd $(PKG_SEL_NODE) && $(DEBUILD)
	
node-headless: get-node-headless_source node-headless-deb-files
	cd $(PKG_SEL_NODE_HEADLESS) && $(DPKG)

node-headless-lp: get-node-headless_source node-headless-deb-files tar-node-headless
	cd $(PKG_SEL_NODE_HEADLESS) && $(DEBUILD)	
	
link:
	cd .. && ln -s $(LINDIR)/$(PKG_SEL_HUB)_*.deb .
	cd .. && ln -s $(LINDIR)/$(PKG_SEL_NODE)_*.deb .
	cd .. && ln -s $(LINDIR)/$(PKG_SEL_NODE_HEADLESS)_*.deb .
	cd .. && ln -s $(LINDIR)/$(PKG_SEL_XVFB)_*.deb	.

local: chk clean hub node node-headless xvfb

all-local: local sign link
	
remote: chk clean hub-lp node-lp node-headless-lp xvfb-lp

remote-upload: hub-lp-upload node-lp-upload node-headless-lp-upload xvfb-lp-upload

all-remote: remote remote-upload

