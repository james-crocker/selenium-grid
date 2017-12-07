@Echo Off


REM Batch to start selenium


Start java -jar c:\selenium\{SELENIUM_SERVER_NODE_JAR} -log c:\selenium\selenium-node.log -role node -nodeConfig c:\selenium\{NODE_CONFIG}


Exit
