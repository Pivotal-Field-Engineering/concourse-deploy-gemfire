#!/bin/bash -e
echo 'Restarting Gemfire Servers'

#Needed to login
#$ export BOSH_CLIENT=ci
#$ export BOSH_CLIENT_SECRET=ci-password

echo $BOSH_CACERT | tr " " "\n" > ca-no-linebreaks.pem
cat ca-no-linebreaks.pem | tr " " "\n" > temp.pem
sed -i '/---/d' temp.pem
echo '-----BEGIN CERTIFICATE-----' > bosh-cacert.pem
cat temp.pem >> bosh-cacert.pem
echo '-----END CERTIFICATE-----' >> bosh-cacert.pem

#BOSH FLOW
bosh --ca-cert bosh-cacert.pem target $BOSH_URL
bosh status
bosh download manifest $DEPLOYMENT_NAME manifest.yml
bosh deployment manifest.yml
bosh --non-interactive restart server-group
