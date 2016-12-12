#!/bin/bash -e
ls -lha
cd java-keystore

# this generates a keystore named gemfire8.keystore and adds a
# public/private key pair to it with an alias named gemfire8

keytool -genkeypair \
-dname "cn=Your Name, ou=GemFire, o=GemStone, c=US" \
-storetype PKCS12 \
-keyalg RSA \
-keysize 2048 \
-alias gemfire8 \
-keystore gemfire8.keystore \
-storepass $KEYSTORE_PASS \
-validity 180
