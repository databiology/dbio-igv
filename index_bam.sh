#!/bin/bash

INPUTRESOURCES=/scratch/inputresources
NP=$(nproc)
LIST=/tmp/bam.list

while read -r FILE; do
    if [ -e "$FILE.bai" ]; then
        echo "*** detected index $FILE.bai"
    else
	    echo "*** index needed for $FILE" 
        echo "$FILE" >> "$LIST"
    fi
done < <(find $INPUTRESOURCES -name "*.bam" )

cat "$LIST" | parallel -j$NP samtools index {}

echo "*** all BAI index created"
touch /tmp/index_bam.done