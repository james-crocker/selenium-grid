# selenium-grid
Tooling for Selenium Grid - Ubuntu Debian packaging

Selenium 3.4.0
Chromedriver 2.31
Geckodriver 0.18.0

Build Debian pacakges with ubuntu/Makefile
- make allclean local
- Creates selenium-hub_#.#.#-0ubuntu1_amd64.deb
- Creates selenium-node_#.#.#-0ubuntu1_amd64.deb
- Creates selenium-node-headless_#.#.#-0ubuntu1_amd64.deb

selenium-node and selenium-node-headless are conflicting and cannot be installed
concurrently. It's either one or the other. selenium-node for GUI workstations.
selenium-node-headless for server installations.

selenium-hub runs standalone or may run concurrently with either one of the node
versions.

There are no released versions in GitHub. A Launchpad PPA has been provided for Ubuntu:

sudo add-apt-repository ppa:siostechcorp/selenium-grid
sudo apt-get update

