#!/bin/bash -e

chmod +x omg-cli/omg-linux

omg-cli/omg-linux register-plugin \
  -type product \
  -pluginpath omg-product-bundle/$PRODUCT_PLUGIN

omg-cli/omg-linux deploy-product \
  --bosh-url $BOSH_URL \
  --bosh-port $BOSH_PORT \
  --bosh-user $BOSH_CLIENT \
  --bosh-pass $BOSH_CLIENT_SECRET \
  --print-manifest \
  --ssl-ignore \
  $PRODUCT_PLUGIN \
  --use-authn \
  --public-key-pass $SECURITY_PUBLIC_KEYPASS \
  --security-client-authenticator $SECURITY_CLIENT_AUTHENTICATOR \
  --security-client-accessor $SECURITY_CLIENT_ACCESSOR \
  --keystore-local-path java-keystore/truststore \
  --security-jar-local-path gemfire-security/$SECURITY_CLIENT_JAR \
  --deployment-name $DEPLOYMENT_NAME \
  --stemcell-ver $STEMCELL_VERSION > manifest/deployment.yml

cat manifest/deployment.yml
#eof
