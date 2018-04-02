#!/bin/bash
# Entrypoint for igv application
# Felipe Leza <felipe.leza@databiology.com>
# Databiology @ 2017

set -euo pipefail

SCRATCH=/scratch
REPORTDIR=$SCRATCH/reports
RESULTDIR=$SCRATCH/results
LOGSDIR=$SCRATCH/logs
IGVDIR=/opt/databiology/apps/IGV


# launch novnc server
/usr/local/bin/start-novnc.sh > /dev/null 2>&1

# launch app with gosu command
gosu dbe $IGVDIR/igv.sh &

child=$!
wait "$child"

echo "IGV stopped"
echo "-----"

