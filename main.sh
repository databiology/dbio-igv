#!/bin/bash
# Entrypoint for igv application
# Felipe Leza <felipe.leza@databiology.com>
# Databiology @ 2017

set -euo pipefail

IGVDIR=/opt/databiology/apps/IGV

# launch app
gosu dbe $IGVDIR/igv.sh &

child=$!
wait "$child"

if find "/scratch/restults" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    echo "Results directory not empty."
else
    echo -e "IGV log file\nNo output was generated\nAuto generated file" >> /scratch/results/IGV_log.txt
fi

echo "IGV stopped"
echo "-----"

