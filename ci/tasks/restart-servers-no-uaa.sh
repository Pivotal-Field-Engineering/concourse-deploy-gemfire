#!/bin/bash
echo 'Restarting Gemfire Servers'

echo $BOSH_CACERT | tr " " "\n" > ca-no-linebreaks.pem
cat ca-no-linebreaks.pem | tr " " "\n" > temp.pem
sed -i '/---/d' temp.pem
echo '-----BEGIN CERTIFICATE-----' > bosh-cacert.pem
cat temp.pem >> bosh-cacert.pem
echo '-----END CERTIFICATE-----' >> bosh-cacert.pem

#BOSH FLOW
bosh target $BOSH_URL
bosh login
bosh status
bosh download manifest $DEPLOYMENT_NAME manifest.yml
bosh deployment manifest.yml
bosh --non-interactive stop server-group --soft
bosh --non-interactive start server-group
