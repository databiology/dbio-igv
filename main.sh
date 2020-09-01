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
PRELOAD=$(jq -r '.["APPLICATION"] .preload' "$SCRATCH/parameters.json")

if [[ "$GENOME" != "null" ]]; then echo "echo 'genome $GENOME'" >> "$LOADER"; fi

# create the bai file for all input files in INPUTRESOURCES 
/usr/local/bin/index_bam.sh &
while true
do 
    if [ -e "/tmp/index_bam.done" ]
    then
        break
    else
        sleep 10
    fi
done

/usr/local/bin/index_vcf.sh &
while true
do 
    if [ -e "/tmp/index_vcf.done" ]
    then
        break
    else
        sleep 10
    fi
done

if [[ "$PRELOAD" == "true" ]]
then
    PATT=""
    if [[ "$REGION" != "null" ]]
    then
        CHR=$(echo "$REGION" | cut -f1 -d":")
        case "$CHR" in
            chr1)
                PATT=22101
                ;;
            chr2)
                PATT=22102
                ;;
            chr3)
                PATT=22103
                ;;
            chr4)
                PATT=22104
                ;;
            chr5)
                PATT=22105
                ;;
            chr6)
                PATT=22106
                ;;
            chr7)
                PATT=22107
                ;;
            chr8)
                PATT=22108
                ;;
            chr9)
                PATT=22109
                ;;
            chr10)
                PATT=22110
                ;;
            chr11)
                PATT=22111
                ;;
            chr12)
                PATT=22112
                ;;
            chr13)
                PATT=22113
                ;;
            chr14)
                PATT=22114
                ;;
            chr15)
                PATT=22115
                ;;
            chr16)
                PATT=22116
                ;;
            chr17)
                PATT=22117
                ;;
            chr18)
                PATT=22118
                ;;
            chr19)
                PATT=22119
                ;;
            chr20)
                PATT=22120
                ;;
            chr21)
                PATT=22121
                ;;
            chr22)
                PATT=22122
                ;;
            chrX)
                PATT=22123
                ;;
            chrY)
                PATT=22124
                ;;
            *)
                echo "Chromosome $CHR is not recognized, please use chr[1..22XY]"
                exit 1
            ;;
        esac
    fi
    for FILE in "$INPUTRESOURCES"/*$PATT*.vcf.gz "$INPUTRESOURCES"/*.bam 
    do
        echo "echo 'load $FILE'" >> "$LOADER"
    done
fi

if [[ "$REGION" != "null" ]]; then echo "echo 'goto $REGION'" >> "$LOADER"; fi

if [[ "$SNAPSHOT" == "true" ]]
then
    echo "snapshotDirectory $RESULTDIR" >> "$LOADER"
    echo "snapshot" >> "$LOADER"
    echo "exit" >> "$LOADER"
fi

if [[ "$PRELOAD" == "true" ]]
then
    gosu dbe $IGVDIR/loader.sh &
fi

# launch app
gosu dbe $IGVDIR/igv.sh &
child=$!

wait "$child"

echo "IGV stopped"
echo "-----"

