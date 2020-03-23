#!/bin/bash
# Entrypoint for igv application
# Felipe Leza <felipe.leza@databiology.com>
# Databiology @ 2020

set -euo pipefail

IGVDIR=/opt/databiology/apps/IGV
SCRATCH=/scratch
SOURCEDIR=${SCRATCH}/input
INPUTRESOURCES=${SCRATCH}/inputresources

# create the bai file for all input files in SOURCEDIR 
while read -r FILE; do
	echo "*** creating index file for $FILE" 
	echo "samtools index ${FILE}"
    samtools index "${FILE}" || echo "Error creating index file"
done < <(find $SOURCEDIR $INPUTRESOURCES -name "*.bam" )

# launch app
gosu dbe $IGVDIR/igv.sh &

child=$!
wait "$child"

if find "/scratch/results" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    echo "Results directory not empty."
else
    echo -e "IGV log file\nApp finished\nAuto generated file" >> /scratch/results/IGV_log.txt
fi

echo "IGV stopped"
echo "-----"

