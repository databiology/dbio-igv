#!/bin/bash
# Carlos De Blas <carlos.deblas@databiology.com>
# (C) 2020 Databiology Inc.

if find "/scratch/results" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
    echo "Results directory not empty."
else
    echo -e "IGV log file\nApp finished\nAuto generated file" >> /scratch/results/IGV_log.txt
fi

touch /scratch/done