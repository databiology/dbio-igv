#!/bin/bash
# Entrypoint for igv application
# Felipe Leza <felipe.leza@databiology.com>
# Databiology @ 2017

set -euo pipefail

IGVDIR=/opt/databiology/apps/IGV

chown dbe:dbe \
    /scratch \
    /scratch/results \
    /scratch/reports \
    /scratch/logs \
    /scratch/work

# launch novnc server
/usr/local/bin/start-novnc.sh

# launch app with gosu command
gosu dbe $IGVDIR/igv.sh &

child=$!
wait "$child"

rm -rf /tmp/.X1-lock

echo "IGV stopped"
echo "-----"

