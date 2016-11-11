#!/bin/bash -e
echo 'Restarting Gemfire Servers'

#BOSH FLOW
bosh target xxx
bosh login
bosh download manifest
bosh restart server-group
