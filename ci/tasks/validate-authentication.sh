#!/bin/bash -e
ls -lha
wget -O "pivotal-gemfire.deb" --post-data="" --header="Authorization: Token ${PIVNET_TOKEN}" https://network.pivotal.io/api/v2/products/pivotal-gemfire/releases/2804/product_files/8892/download
sudo dpkg -i pivotal-gemfire.deb

gfsh version
gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "list members" \
-e "create region --name=test-region --type=PARTITION_REDUNDANT" \
-e "list regions"

LOCATOR_IP=$(echo $LOCATOR_CONNECTION | cut -d'[' -f 1)
LOCATOR_PORT=$(echo $LOCATOR_CONNECTION | cut -d'[' -f 2 | cut -d']' -f 1)
echo '<?xml version="1.0"?>' >> gemfire.xml
echo '<!DOCTYPE client-cache PUBLIC' >> gemfire.xml
echo '"-//GemStone Systems, Inc.//GemFire Declarative Caching 6.5//EN"' >> gemfire.xml
echo '"http://www.gemstone.com/dtd/cache6_5.dtd">' >> gemfire.xml
echo '<client-cache>' >> gemfire.xml
echo "<pool name=\"client\" subscription-enabled=\"false\"><locator host=\"$LOCATOR_IP\" port=\"10334\"/></pool>" >> gemfire.xml
echo '<region name="test-region" refid="PROXY"/>' >> gemfire.xml
echo '</client-cache>' >> gemfire.xml
cat gemfire.xml

#Test with valid client
echo "name=SecurityPkcsClient" >> valid-client.properties
echo "cache-xml-file=gemfire.xml.xml" >> valid-client.properties
echo "security-client-auth-init=templates.security.PKCSAuthInit.create" >> valid-client.properties
echo "security-keystorepath=test-client-keys/valid-client.keystore" >> valid-client.properties
echo "security-alias=valid-client" >> valid-client.properties
echo "security-keystorepass=$SECURITY_PUBLIC_KEYPASS" >> valid-client.properties
cat valid-client.properties

#eventually get the version number from POM....  Hardcoded now
java  -Done-jar.main.class=com.tmo.security.SecurityPkcsClient \
-jar gemfire-security/$TEST_JAR \
valid-client.properties test-region >> valid-client.log
cat valid-client.log

cat valid-client.log | grep "Auth Success"
