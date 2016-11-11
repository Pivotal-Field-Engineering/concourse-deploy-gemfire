#!/bin/bash -e
wget -O "pivotal-gemfire.deb" --post-data="" --header="Authorization: Token ${PIVNET_TOKEN}" https://network.pivotal.io/api/v2/products/pivotal-gemfire/releases/2804/product_files/8892/download
sudo dpkg -i pivotal-gemfire.deb

echo 'Enabling PDX'

gfsh version
gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "configurea pdx --read-serialized=true --disk-store=pdx_store --ignore-unread-fields=false --portable-auto-serializable-classes=com.tmo.*"
