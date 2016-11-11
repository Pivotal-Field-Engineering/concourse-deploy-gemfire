#!/bin/bash -e

if $REST_API_ACTIVE
then

ls -lha
wget -O "pivotal-gemfire.deb" --post-data="" --header="Authorization: Token ${PIVNET_TOKEN}" https://network.pivotal.io/api/v2/products/pivotal-gemfire/releases/2804/product_files/8892/download
sudo dpkg -i pivotal-gemfire.deb

gfsh version
SERVER_IP="$(gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "list members" | \
grep cacheserver-0 | cut -d ' ' -f 3 | cut -d '(' -f 1)"
echo "Testing rest API on ${SERVER_IP}"

REST_ENDPOINT="http://$SERVER_IP:$REST_API_PORT/gemfire-api/v1/ping"
echo "Full connection URL ${REST_ENDPOINT}"

curl -vs ${REST_ENDPOINT} 2>&1

else
echo "REST API is not enabled in config"
fi
