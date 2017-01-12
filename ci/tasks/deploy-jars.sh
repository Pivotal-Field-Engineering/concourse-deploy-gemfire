#!/bin/bash
wget -O "pivotal-gemfire.deb" --post-data="" --header="Authorization: Token ${PIVNET_TOKEN}" $GEMFIRE_CLIENT_URL
sudo dpkg -i pivotal-gemfire.deb

echo 'Deploying Auth Jars: $JAR'

#Need to always us same name otherwise the GF Classpath isn't updated and new changes don't take affect
cp gemfire-security/$JAR gemfire-security/authz.jar

gfsh version
gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "deploy --jar=gemfire-security/authz.jar"
