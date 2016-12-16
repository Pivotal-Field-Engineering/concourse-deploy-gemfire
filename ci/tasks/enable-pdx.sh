#!/bin/bash
wget -O "pivotal-gemfire.deb" --post-data="" --header="Authorization: Token ${PIVNET_TOKEN}" $GEMFIRE_CLIENT_URL
sudo dpkg -i pivotal-gemfire.deb

echo 'Enabling PDX'

gfsh version
gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "create disk-store --name=pdx_store --dir=/var/vcap/data/pdx_store" \
-e "configure pdx --read-serialized=true --disk-store=pdx_store --ignore-unread-fields=false --portable-auto-serializable-classes=com.tmo.*" \
