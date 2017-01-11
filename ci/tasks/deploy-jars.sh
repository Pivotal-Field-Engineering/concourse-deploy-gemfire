#!/bin/bash
wget -O "pivotal-gemfire.deb" --post-data="" --header="Authorization: Token ${PIVNET_TOKEN}" $GEMFIRE_CLIENT_URL
sudo dpkg -i pivotal-gemfire.deb

echo 'Deploying Auth Jars: $JAR'

gfsh version
gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "deploy --jar=gemfire-security/$JAR"
