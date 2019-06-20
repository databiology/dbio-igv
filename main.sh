#!/bin/bash
# Entrypoint for igv application
# Felipe Leza <felipe.leza@databiology.com>
# Databiology @ 2017

set -euo pipefail

IGVDIR=/opt/databiology/apps/IGV

# launch novnc server
/usr/local/bin/start-novnc.sh > /dev/null 2>&1

# launch app
$IGVDIR/igv.sh &

child=$!
wait "$child"

if find "/scratch/restults" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    echo "Results directory not empty."
else
    touch /scratch/restults/IGV.txt
    echo -e "IGV log file\nNo output was generated\nAuto generated file" >> /scratch/restults/IGV.log
fi

echo "IGV stopped"
echo "-----"

