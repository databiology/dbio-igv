#!/bin/bash

INPUTRESOURCES=/scratch/inputresources
NP=$(nproc)
LIST=/tmp/vcf.list

while read -r FILE; do
    if [ -e "$FILE.tbi" ]; then
        echo "*** detected index file $FILE.tbi"
    else
        echo "*** index file needed for $FILE" 
        echo "$FILE" >> "$LIST"
    fi
done < <(find $INPUTRESOURCES -name "*.vcf.gz" )

if [ -e "$LIST" ]
then
    cat "$LIST" | parallel -j$NP VCFindex.sh {}
    echo "*** all TBI index created"
fi
touch /tmp/index_vcf.done