#!/bin/bash -e
set -xe
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
PATH=$JAVA_HOME/bin:$PATH:$HOME/bin
export JAVA_HOME
export JRE_HOME
export PATH

ls -lha
wget -O "pivotal-gemfire.deb" --post-data="" --header="Authorization: Token ${PIVNET_TOKEN}" $GEMFIRE_CLIENT_URL
dpkg -i pivotal-gemfire.deb

gfsh version
gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "list members" \
-e "create region --name=testRegion --type=PARTITION_REDUNDANT" \
-e "create region --name=testAuthzRegion --type=PARTITION_REDUNDANT" \
-e "list regions"

LOCATOR_IP=$(echo $LOCATOR_CONNECTION | cut -d'[' -f 1)
LOCATOR_PORT=$(echo $LOCATOR_CONNECTION | cut -d'[' -f 2 | cut -d']' -f 1)
echo '<?xml version="1.0"?>' >> gemfire.xml
echo '<!DOCTYPE client-cache PUBLIC' >> gemfire.xml
echo '"-//GemStone Systems, Inc.//GemFire Declarative Caching 6.5//EN"' >> gemfire.xml
echo '"http://www.gemstone.com/dtd/cache6_5.dtd">' >> gemfire.xml
echo '<client-cache>' >> gemfire.xml
echo "<pool name=\"client\" subscription-enabled=\"false\"><locator host=\"$LOCATOR_IP\" port=\"$LOCATOR_PORT\"/></pool>" >> gemfire.xml
echo '<region name="testRegion" refid="PROXY"/>' >> gemfire.xml
echo '<region name="testAuthzRegion" refid="PROXY"/>' >> gemfire.xml
echo '</client-cache>' >> gemfire.xml
cat gemfire.xml

#Test with valid client
echo "name=SecurityPkcsClient" >> valid-client.properties
echo "cache-xml-file=gemfire.xml" >> valid-client.properties
echo "security-client-auth-init=templates.security.PKCSAuthInit.create" >> valid-client.properties
echo "security-keystorepath=test-client-keys-valid/valid-client.keystore" >> valid-client.properties
echo "security-alias=valid-client" >> valid-client.properties
echo "security-keystorepass=$SECURITY_PUBLIC_KEYPASS" >> valid-client.properties
cat valid-client.properties

java  -Done-jar.main.class=com.tmo.security.SecurityPkcsClient \
-jar gemfire-security/$TEST_JAR \
valid-client.properties testRegion >> valid-client.log
cat valid-client.log

#Test with valid client but region w/o authz
java  -Done-jar.main.class=com.tmo.security.SecurityPkcsClient \
-jar gemfire-security/$TEST_JAR \
valid-client.properties testAuthzRegion >> invalid-client.log
cat invalid-client.log

gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "destroy region --name=/testRegion" \
-e "destroy region --name=/testAuthzRegion" \
-e "list regions"

cat valid-client.log | grep "Authz Success" &&
cat invalid-client.log | grep "NotAuthorizedException: Not authorized to perform GET operation on region"
