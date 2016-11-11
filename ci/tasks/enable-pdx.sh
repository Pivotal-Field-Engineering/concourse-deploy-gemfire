#!/bin/bash -e
echo 'Enabling PDX'

gfsh version
gfsh \
-e "connect --locator=${LOCATOR_CONNECTION}" \
-e "configure11 pdx --read-serialized=true --disk-store=pdx_store --ignore-unread-fields=false --portable-auto-serializable-classes=com.tmo.*"
