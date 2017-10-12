#!/bin/bash
temp_inK=300
for cfile in ubq_gbis_eq_job?.conf 
do 
    sed "s/^set temperature.*/set temperature   $temp_inK/" $cfile >  1.tmp.out
    mv 1.tmp.out $cfile
done 
