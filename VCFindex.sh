#!/bin/bash

FILE=$1
gunzip -c "${FILE}" | vcf-sort | grep -v "FAIL" > "${FILE}.sort"
bgzip "${FILE}.sort"
rm "${FILE}"
mv "${FILE}.sort.gz" "${FILE}"
tabix "${FILE}"
