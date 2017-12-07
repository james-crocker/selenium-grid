# This Makefile builds the builds
#
# Windows zip file containing stand-alone Selenium NODE with IE, Edge, Chrome and
# Firefox webdrivers.
# Ubunutu deb packages for Selenium GRID (Hub & Node), headless XVFB with
# Chrome and Firefox webdrivers.
export TMPDIR=/tmp/selenium-grid-sources
export WINDIR=windows
export LINDIR=ubuntu

# Ubuntu Debian and Windows zip versions
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Make sure versions match packages most recent changelog entry
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# debuild doesn't use the full change log version which would read
# 1.0.0+1SNAPSHOT201702091400-1ubuntu0
export LP_HUB_VER=1.1.2
export LP_NODE_VER=1.1.2
export LP_NODE_HEADLESS_VER=1.1.2
export LP_XVFB_VER=1.1.2
export LP_UBUNTU_VER=-0ubuntu1

# Windows zip product - to be unzipped on windows vm in C:\Selenium
export SELENIUM_SOURCES_HOST=hancock
export SELENIUM_WIN10_ZIP=selenium-node-win10-v$(LP_NODE_VER)$(ZIP_SUFFIX)
export SELENIUM_WIN10_ZIP_TGT=$(SELENIUM_SOURCES_HOST):/filepile/software/selenium-grid-sources/$(SELENIUM_WIN10_ZIP)

# Selenium and linux/windows webdrivers
export SELENIUM_VER=3.8
export SELENIUM_SERVER_VER=3.8.1
export SELENIUM_NAME=selenium-server-standalone
export CHROMEDRIVER_VER=2.33
export CHROMEDRIVER_NAME=chromedriver
export GECKODRIVER_VER=0.19.1
export GECKODRIVER_NAME=geckodriver
export IEDRIVER_VER=3.8.0
export IEDRIVER_NAME=IEDriverServer
export EDGEDRIVER_VER=16299
export EDGEDRIVER_NAME=MicrosoftWebDriver
export EXE_SUFFIX=.exe
export ZIP_SUFFIX=.zip
export JAR_SUFFIX=.jar
export TAR_GZ_SUFFIX=.tar.gz

# Selenium and linux/win10 webdriver sources
export SELENIUM_SERVER_SRC=http://selenium-release.storage.googleapis.com/$(SELENIUM_VER)/$(SELENIUM_NAME)-$(SELENIUM_SERVER_VER)$(JAR_SUFFIX)
export CHROMEDRIVER_SRC=https://chromedriver.storage.googleapis.com/$(CHROMEDRIVER_VER)/$(CHROMEDRIVER_NAME)_linux64$(ZIP_SUFFIX)
export CHROMEDRIVER_WIN10_SRC=https://chromedriver.storage.googleapis.com/$(CHROMEDRIVER_VER)/$(CHROMEDRIVER_NAME)_win32$(ZIP_SUFFIX)
export GECKODRIVER_SRC=https://github.com/mozilla/geckodriver/releases/download/v$(GECKODRIVER_VER)/$(GECKODRIVER_NAME)-v$(GECKODRIVER_VER)-linux64$(TAR_GZ_SUFFIX)
export GECKODRIVER_WIN10_SRC=https://github.com/mozilla/geckodriver/releases/download/v$(GECKODRIVER_VER)/$(GECKODRIVER_NAME)-v$(GECKODRIVER_VER)-win64$(ZIP_SUFFIX)
export IEDRIVER_SRC=http://selenium-release.storage.googleapis.com/$(SELENIUM_VER)/$(IEDRIVER_NAME)_x64_$(IEDRIVER_VER)$(ZIP_SUFFIX)
export EDGEDRIVER_SRC=https://download.microsoft.com/download/D/4/1/D417998A-58EE-4EFE-A7CC-39EF9E020768/$(EDGEDRIVER_NAME)$(EXE_SUFFIX)

# Archive download temporary filenames
export CHROMEDRIVER_ARCHIVE=$(CHROMEDRIVER_NAME)-linux$(ZIP_SUFFIX)
export CHROMEDRIVER_WIN10_ARCHIVE=$(CHROMEDRIVER_NAME)-win10$(ZIP_SUFFIX)
export GECKODRIVER_ARCHIVE=$(GECKODRIVER_NAME)-linux$(TAR_GZ_SUFFIX)
export GECKODRIVER_WIN10_ARCHIVE=$(GECKODRIVER_NAME)-win10$(ZIP_SUFFIX)
export IEDRIVER_ARCHIVE=$(IEDRIVER_NAME)$(ZIP_SUFFIX)
export EDGEDRIVER_ARCHIVE=$(EDGEDRIVER_NAME)$(EXE_SUFFIX)

# Debian package and Windows zip selenium and webdriver filenames
export SELENIUM_SERVER_HUB_JAR=selenium-hub-v$(SELENIUM_SERVER_VER)$(JAR_SUFFIX)
export SELENIUM_SERVER_NODE_JAR=selenium-node-v$(SELENIUM_SERVER_VER)$(JAR_SUFFIX)
export CHROMEDRIVER_BIN=$(CHROMEDRIVER_NAME)-v$(CHROMEDRIVER_VER)
export CHROMEDRIVER_WIN10_BIN=$(CHROMEDRIVER_NAME)-v$(CHROMEDRIVER_VER)$(EXE_SUFFIX)
export GECKODRIVER_BIN=$(GECKODRIVER_NAME)-v$(GECKODRIVER_VER)
export GECKODRIVER_WIN10_BIN=$(GECKODRIVER_NAME)-v$(GECKODRIVER_VER)$(EXE_SUFFIX)
export IEDRIVER_BIN=$(IEDRIVER_NAME)-v$(IEDRIVER_VER)$(EXE_SUFFIX)
export EDGEDRIVER_BIN=$(EDGEDRIVER_NAME)-v$(EDGEDRIVER_VER)$(EXE_SUFFIX)

export ALERT='!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

# Semaphores
export LINUX_SEMPH="$(TMPDIR)/semaphore-linux"
export WIN10_SEMPH="$(TMPDIR)/semaphore-win10"

.PHONY: clean rm-semph-linux rm-semph-win get-sources windows-local \
windows-remote ubuntu-local ubuntu-remote all-local all-remote

clean:
	-rm -rf $(TMPDIR)
	make -C $(WINDIR) clean
	make -C $(LINDIR) clean
	
rm-semph-linux:
	-rm -f $(LINUX_SEMPH)
	
rm-semph-win:
	-rm -f $(WIN10_SEMPH)
	
get-sources:
	@if [ -d $(TMPDIR) ]; then \
		if [ -f $(LINUX_SEMPH) ] || [ -f $(WIN10_SEMPH) ]; \
		then \
			:; \
		else \
			echo $(ALERT); \
			echo "\nWARNING: [$(TMPDIR)] exists and may contain stale data. \
Consider 'make clean'\n"; \
			echo $(ALERT); \
		fi \
	else \
		echo "Downloading Selenium and Linux/Window web drivers to $(TMPDIR)..."; \
		mkdir $(TMPDIR); \
		cd $(TMPDIR); \
		wget -t 5 $(SELENIUM_SERVER_SRC) -O $(SELENIUM_NAME); \
		chmod 644 $(SELENIUM_NAME); \
		wget -t 5 $(CHROMEDRIVER_SRC) -O $(CHROMEDRIVER_ARCHIVE); \
		unzip $(CHROMEDRIVER_ARCHIVE); \
		mv $(CHROMEDRIVER_NAME) $(CHROMEDRIVER_BIN); \
		chmod 755 $(CHROMEDRIVER_BIN); \
		wget -t 5 $(CHROMEDRIVER_WIN10_SRC) -O $(CHROMEDRIVER_WIN10_ARCHIVE); \
		unzip $(CHROMEDRIVER_WIN10_ARCHIVE); \
		mv $(CHROMEDRIVER_NAME)$(EXE_SUFFIX) $(CHROMEDRIVER_WIN10_BIN); \
		chmod 755 $(CHROMEDRIVER_WIN10_BIN); \
		wget -t 5 $(GECKODRIVER_SRC) -O $(GECKODRIVER_ARCHIVE); \
		tar xvfpz $(GECKODRIVER_ARCHIVE); \
		mv $(GECKODRIVER_NAME) $(GECKODRIVER_BIN); \
		chmod 755 $(GECKODRIVER_BIN); \
		wget -t 5 $(GECKODRIVER_WIN10_SRC) -O $(GECKODRIVER_WIN10_ARCHIVE); \
		unzip $(GECKODRIVER_WIN10_ARCHIVE); \
		mv $(GECKODRIVER_NAME)$(EXE_SUFFIX) $(GECKODRIVER_WIN10_BIN); \
		chmod 644 $(GECKODRIVER_WIN10_BIN); \
		wget -t 5 $(IEDRIVER_SRC) -O $(IEDRIVER_ARCHIVE); \
		unzip $(IEDRIVER_ARCHIVE); \
		mv $(IEDRIVER_NAME)$(EXE_SUFFIX) $(IEDRIVER_BIN); \
		chmod 644 $(IEDRIVER_BIN); \
		wget -t 5 $(EDGEDRIVER_SRC) -O $(EDGEDRIVER_ARCHIVE); \
		mv $(EDGEDRIVER_NAME)$(EXE_SUFFIX) $(EDGEDRIVER_BIN); \
		chmod 644 $(EDGEDRIVER_BIN); \
	fi

windows-local: rm-semph-win get-sources rm-semph-win
	@echo Creating [Local Window] Selenium NODE package [$(SELENIUM_WIN10_ZIP)]...
	@touch $(WIN10_SEMPH)
	make -C $(WINDIR) all-local
	@echo unzip $(SELENIUM_WIN10_ZIP_TGT) at win10 vm C:\\
	
windows-remote: rm-semph-win get-sources rm-semph-win
	@echo Creating [Remote Window] Selenium NODE package [$(SELENIUM_WIN10_ZIP_TGT)]...
	@touch $(WIN10_SEMPH)
	make -C $(WINDIR) all-remote
	@echo unzip $(SELENIUM_WIN10_ZIP_TGT) at win10 vm C:\\
	
ubuntu-local: rm-semph-linux get-sources rm-semph-linux
	@echo Creating [Local Linux] Selenium GRID Debian Packages...
	@touch $(LINUX_SEMPH)
	make -C $(LINDIR) all-local
	@echo dpkg \-i @fvorge

ubuntu-remote: rm-semph-linux get-sources rm-semph-linux
	@echo Creating [Remote Linux] Selenium GRID Debian Packages [Launchpad]...
	@touch $(LINUX_SEMPH)
	make -C $(LINDIR) all-remote
	
all-local: windows-local ubuntu-local
	@echo "Done. To release; make all-remote"
	
all-remote: windows-remote ubuntu-remote
	@echo "Done."
		

