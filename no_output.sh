#!/bin/bash
# Entrypoint for Beast application
# Carlos De Blas <carlos.deblas@databiology.com>
# (C) 2019 Databiology Inc.

if find "/scratch/restults" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    echo "Results directory not empty."
else
    echo -e "Beast log file\nNo output was generated\nAuto generated file" >> /scratch/results/Beast_log.txt
fi

touch /scratch/done