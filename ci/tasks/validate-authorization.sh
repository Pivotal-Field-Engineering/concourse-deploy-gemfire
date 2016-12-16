#!/bin/bash -e
ls -lha
wget -O "pivotal-gemfire.deb" --post-data="" --header="Authorization: Token ${PIVNET_TOKEN}" $GEMFIRE_CLIENT_URL
sudo dpkg -i pivotal-gemfire.deb

gfsh version
gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "list members"
