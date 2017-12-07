# This Makefile builds the windows selenium zip locally or remote

# Zip archive relative to C:\selenium
WIN_DIR=selenium
TGT_DIR=$(TMPDIR)/$(WIN_DIR)
START_BAT=start-selenium.bat
export NODE_CONFIG=nodeConfig-WIN10.json

.PHONY: chk clean all-local all-remote

chk:
	@if [ -z $(TMPDIR) ]; \
	then \
		echo "Must be called from parent ../Makefile"; \
		exit 1; \
	fi
	
clean: chk
	-rm -rf $(TGT_DIR)
	-rm -f $(SELENIUM_WIN10_ZIP)
	-rm -f ../$(SELENIUM_WIN10_ZIP)
			
all-local: chk clean
	mkdir $(TGT_DIR)
	cp $(TMPDIR)/$(SELENIUM_NAME) $(TGT_DIR)/$(SELENIUM_SERVER_NODE_JAR)
	cp $(TMPDIR)/$(CHROMEDRIVER_WIN10_BIN) $(TGT_DIR)/$(CHROMEDRIVER_WIN10_BIN)
	cp $(TMPDIR)/$(GECKODRIVER_WIN10_BIN) $(TGT_DIR)/$(GECKODRIVER_WIN10_BIN)
	cp $(TMPDIR)/$(IEDRIVER_BIN) $(TGT_DIR)/$(IEDRIVER_BIN)
	cp $(TMPDIR)/$(EDGEDRIVER_BIN) $(TGT_DIR)/$(EDGEDRIVER_BIN)
	perl -pe 's#{SELENIUM_SERVER_NODE_JAR}#$$ENV{SELENIUM_SERVER_NODE_JAR}#g; \
	s#{NODE_CONFIG}#$$ENV{NODE_CONFIG}#g;' $(START_BAT) > $(TGT_DIR)/$(START_BAT)
	perl -pe 's#{CHROMEDRIVER}#$$ENV{CHROMEDRIVER_WIN10_BIN}#g; \
	s#{GECKODRIVER}#$$ENV{GECKODRIVER_WIN10_BIN}#g; \
	s#{EDGEDRIVER}#$$ENV{EDGEDRIVER_BIN}#g; \
	s#{IEDRIVER}#$$ENV{IEDRIVER_BIN}#g;' $(NODE_CONFIG) > $(TGT_DIR)/$(NODE_CONFIG)
	cd $(TMPDIR) && zip -r $(SELENIUM_WIN10_ZIP) $(WIN_DIR)
	mv $(TMPDIR)/$(SELENIUM_WIN10_ZIP) .
	cd .. && ln -s $(WINDIR)/$(SELENIUM_WIN10_ZIP) .
	
all-remote: all-local
	@echo $(ALERT)
	@echo "\nSSH keys or known password for user [$(USER)] must be properly \
configured at [$(SELENIUM_SOURCES_HOST)]\n"
	@echo $(ALERT)
	scp $(SELENIUM_WIN10_ZIP) $(SELENIUM_WIN10_ZIP_TGT)
		
	
