# This Makefile builds the builds

export JOB_NAME='Selenium-Grid Packaging'

# Source not in Git; fetch for unpacking
# $SRC_SSH_USER must be set!
SRC_HOST=hancock.sc.steeleye.com
SRC_PATH=/filepile/software/selenium-grid-sources
SRC_TMP_DIR=tmpsrc
RM = /bin/rm
ALERT='!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

.PHONY: clean prep

all: getsource selenium-hub selenium-node selenium-node-headless

selenium-hub: getsource
	cd selenium-hub && make all

selenium-node: getsource
	cd selenium-node && make all

selenium-node-headless: getsource
	cd selenium-node-headless && make all

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
		ssh $(SRC_SSH_USER)@$(SRC_HOST) "(cd $(SRC_PATH) && tar cf - *)" | tar xvf -; \
	fi

clean:
	cd selenium-hub && make clean
	cd selenium-node && make clean
	cd selenium-node-headless && make clean
	$(RM) -rf $(SRC_TMP_DIR)

