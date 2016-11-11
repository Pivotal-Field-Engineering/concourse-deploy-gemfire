#!/bin/bash -e
echo 'Restarting Gemfire Servers'

#Needed to login
#$ export BOSH_CLIENT=ci
#$ export BOSH_CLIENT_SECRET=ci-password

echo $BOSH_CACERT > bosh-cacert.cer
ls -l

#BOSH FLOW
bosh --ca-cert bosh-cacert.cer target $BOSH_URL
bosh status
bosh download manifest
bosh restart server-group
