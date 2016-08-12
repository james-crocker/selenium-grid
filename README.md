# selenium-grid
Tooling for Selenium Grid - Ubuntu Debian packaging

Build Debian pacakges with ubuntu/Makefile
- make
- Creates selenium-hub.deb (depends: openjdk-7-jre-headless)
- Creates selenium-node.deb (depends: google-chrome-stable, firefox, openjdk-7-jre)
- Creates selenium-node-headless.deb (depends: google-chrome-stable, firefox, xvfb, openjdk-7-jre-headless)

selenium-node and selenium-node-headless are conflicting and cannot be installed
concurrently. It's either one or the other. selenium-node for GUI workstations.
selenium-node-headless for server installations.

selenium-hub runs standalone or may run concurrently with either one of the node
versions.

Selenium source and related material is *not* stored in the repository. SSH
access to hancock.sc.steeleye.com must exist. Prior to building export
SRC_SSH_USER=<hancockUserName>

