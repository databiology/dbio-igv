#!/bin/bash
# Entrypoint for igv application
# Felipe Leza <felipe.leza@databiology.com>
# Databiology @ 2017

set -euo pipefail

SCRATCH=/scratch
IGVDIR=/opt/databiology/apps/IGV/

DIEVER=$(cat < $SCRATCH/ingestion.json | jq -r '.version')
if [ "$DIEVER" != "0.1" ]; then
    echo "WARNING: Version of ingestion engine equals not 0.1"
fi

# launch novnc server
/usr/local/bin/start-novnc.sh

# launch app with gosu command
gosu ${DBE_WORKUNIT_USERNAME} $IGVDIR/igv.sh &

child=$!
wait "$child"

echo "IGV stopped"
echo "-----"