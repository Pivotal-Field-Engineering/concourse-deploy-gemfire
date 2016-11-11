#!/bin/bash -e
echo 'Restarting Gemfire Servers'

#BOSH FLOW
bosh target $BOSH_URL
bosh login
bosh download manifest
bosh restart server-group
