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

#Invalid Keystore
keytool -genkeypair \
-dname "cn=Your Name, ou=GemFire, o=GemStone, c=US" \
-storetype PKCS12 \
-keyalg RSA \
-keysize 2048 \
-alias invalid-client \
-keystore invalid-client.keystore \
-storepass $KEYSTORE_PASS \
-validity 180
