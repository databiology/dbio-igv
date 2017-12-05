#!/bin/bash
# Entrypoint for igv application
# Felipe Leza <felipe.leza@databiology.com>
# Databiology @ 2017

set -euo pipefail

# launch novnc server
/usr/local/bin/start-novnc.sh > /dev/null 2>&1

# runnning IGV
SCRATCH=/scratch
IGVDIR=/opt/databiology/apps/IGV

# read parameters from parameters.json
DIEVER=$(cat < $SCRATCH/ingestion.json | jq -r '.version')
if [ "$DIEVER" != "0.1" ]; then
    echo "WARNING: Version of ingestion engine equals not 0.1"
fi

# launch app with gosu command
gosu dbe $IGVDIR/igv.sh &

child=$!
wait "$child"

echo "IGV stopped"
echo "-----"