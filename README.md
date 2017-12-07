# selenium-grid
Tooling for Selenium Grid - Ubuntu Debian packaging

Selenium 3.8.1
Chromedriver 2.33
Geckodriver 0.19.1

Make LOCAL first:

make all-local

This creates a windows zip archive to be extracted at C:\ of the win10 target
vm and the *.deb ubuntu packages. Assure that all the hub and node install and
run. If satisfied with the results run make again to save zip archive to 
hancock and the ubuntu debian packages to SIOS Technology Corp. Launchpad PPA.

make all-remote

selenium-node and selenium-node-headless are conflicting and cannot be installed
concurrently. It's either one or the other. selenium-node for GUI workstations.
selenium-node-headless for server installations.

selenium-hub runs standalone or may run concurrently with either one of the node
versions.

There are no released versions in GitHub. A Launchpad PPA has been provided for Ubuntu:

sudo add-apt-repository ppa:siostechcorp/selenium-grid
sudo apt-get update

fvorge.sc.steeleye.com has this apt source.
minion27, minion28 and minion29.sc.steeleye.com have the zip archive extracted
from the root of C:\ and the start script and supporting selenium jar and
webdrivers in C:\selenium.

