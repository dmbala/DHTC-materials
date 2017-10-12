#!/bin/bash
echo "  "  > energy_values.dat
for tzfile in OutFilesFromNAMD_job*.tar.gz
do
    tar -xzf $tzfile --wildcards --no-anchored 'ubq_gbis_eq_job*.log'
    grep "ENERGY:" OutFilesFromNAMD_job*/ubq*.log  >> energy_values.dat
    rm -rf OutFilesFromNAMD_job?
done

