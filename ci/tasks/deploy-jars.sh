#!/bin/bash
wget -O "pivotal-gemfire.deb" --post-data="" --header="Authorization: Token ${PIVNET_TOKEN}" https://network.pivotal.io/api/v2/products/pivotal-gemfire/releases/2804/product_files/8892/download
sudo dpkg -i pivotal-gemfire.deb

echo 'Deploying Auth Jars'

gfsh version
gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "deploy --jar=security-release/$JAR"
