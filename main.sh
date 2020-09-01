#!/bin/bash
# Entrypoint for IGV application
# Felipe Leza <felipe.leza@databiology.com>
# (C) 2020 Databiology

set -euo pipefail

IGVDIR=/opt/databiology/apps/IGV
SCRATCH=/scratch
#SOURCEDIR=${SCRATCH}/input
RESULTDIR=${SCRATCH}/results
INPUTRESOURCES=${SCRATCH}/inputresources
LOADER="$SCRATCH/loader.sh"

echo "" > "$LOADER"

# Read parameters from parameters.json
GENOME=$(jq -r '.["APPLICATION"] .genome' "$SCRATCH/parameters.json")
REGION=$(jq -r '.["APPLICATION"] .region' "$SCRATCH/parameters.json")
SNAPSHOT=$(jq -r '.["APPLICATION"] .snapshot' "$SCRATCH/parameters.json")

if [[ "$GENOME" != "null" ]]; then echo "echo 'genome $GENOME'" >> "$LOADER"; fi

# create the bai file for all input files in INPUTRESOURCES 
while read -r FILE; do
    if [ -e "$FILE.bai" ]; then
        echo "*** detected index $FILE.bai"
    else
	    echo "*** creating index file for $FILE" 
	    echo "samtools index ${FILE}"
        samtools index "${FILE}" || echo "Error creating index file"
    fi
    echo "echo 'load $FILE'" >> "$LOADER"
done < <(find $INPUTRESOURCES -name "*.bam" )

while read -r FILE; do
    if [ -e "$FILE.tbi" ]; then
        echo "*** detected index file $FILE.tbi"
    else
        echo "*** creating index file for $FILE" 
        gunzip -c "${FILE}" | vcf-sort | grep -v "FAIL" > "${FILE}.sort"
        bgzip "${FILE}.sort"
        rm "${FILE}"
        mv "${FILE}.sort.gz" "${FILE}"
        tabix "${FILE}"
    fi
    echo "echo 'load $FILE'" >> "$LOADER"
done < <(find $INPUTRESOURCES -name "*.vcf.gz" )

if [[ "$REGION" != "null" ]]; then echo "echo 'goto $REGION'" >> "$LOADER"; fi
if [[ "$SNAPSHOT" == "true" ]]
then
    echo "snapshotDirectory $RESULTDIR" >> "$LOADER"
    echo "snapshot" >> "$LOADER"
    echo "exit" >> "$LOADER"
fi

# launch app
gosu dbe $IGVDIR/igv.sh &
child=$!

# preload data
sh "$LOADER" | telnet 127.0.0.1 60151

# wait main taks before finishing
wait "$child"

echo "IGV stopped"
echo "-----"

