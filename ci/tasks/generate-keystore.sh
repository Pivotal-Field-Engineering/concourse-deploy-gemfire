#!/bin/bash -e
set -xe

ls -lha
cd java-keystore

#Valid Cert
keytool -genkeypair \
-dname "cn=Your Name, ou=GemFire, o=GemStone, c=US" \
-storetype PKCS12 \
-keyalg RSA \
-keysize 2048 \
-alias valid-client \
-keystore valid-client.keystore \
-storepass $KEYSTORE_PASS \
-validity 180

keytool -exportcert \
-storetype PKCS12 \
-keyalg RSA \
-keysize 2048 \
-alias valid-client \
-keystore valid-client.keystore \
-storepass $KEYSTORE_PASS \
-rfc \
-file valid-client.cer

keytool -import \
-file valid-client.cer \
-alias valid-client \
-keystore truststore \
-storepass $KEYSTORE_PASS \
-noprompt

#Import anything the client cert repo into truststore
for CERT in ../client-cert-repo/$CERT_FOLDER/*
do
  echo "Processing $CERT client certificate..."
  FNAME=$(basename "$CERT")
  ALIAS=`echo "$FNAME" | cut -d'.' -f1`
  keytool -import \
  -file $CERT \
  -alias $ALIAS \
  -keystore truststore \
  -storepass $KEYSTORE_PASS \
  -noprompt
done

keytool -list -keystore truststore -storepass $KEYSTORE_PASS


#Invalid Keystore for testing later
keytool -genkeypair \
-dname "cn=Your Name, ou=GemFire, o=GemStone, c=US" \
-storetype PKCS12 \
-keyalg RSA \
-keysize 2048 \
-alias invalid-client \
-keystore invalid-client.keystore \
-storepass $KEYSTORE_PASS \
-validity 180
