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

while read -r FILE; do
	echo "*** creating index file for $FILE" 
    gunzip -c "${FILE}" | vcf-sort | grep -v "FAIL" > "${FILE}.sort"
    bgzip "${FILE}.sort"
    rm "${FILE}"
    mv "${FILE}.sort.gz" "${FILE}"
    tabix "${FILE}"
done < <(find $SOURCEDIR $INPUTRESOURCES -name "*.vcf.gz" )

# launch app
gosu dbe $IGVDIR/igv.sh &

child=$!
wait "$child"

echo "IGV stopped"
echo "-----"

