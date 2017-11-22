#!/bin/bash

# Entrypoint for igv application
# Felipe Leza <felipe.leza@databiology.com>
# Databiology @ 2017

set -euo pipefail

# launch novnc server
/usr/local/bin/start-novnc.sh

# runnning IGV
SCRATCH=/scratch
IGVDIR=/opt/databiology/apps/IGV/

# read parameters from parameters.json
DIEVER=$(cat < $SCRATCH/ingestion.json | jq -r '.version')
if [ "$DIEVER" != "0.1" ]; then
    echo "WARNING: Version of ingestion engine equals not 0.1"
fi

# launch app
$IGVDIR/igv.sh

# this loop is required to execute the app
while true; do sleep 100; done




