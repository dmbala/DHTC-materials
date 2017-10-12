#!/bin/bash
tar xzf OutFilesFromNAMD_job1.tar.gz 
mv OutFilesFromNAMD_job1/*job1.restart* .

module load namd/2.9
namd2 ubq_gbis_eq_job2.conf > ubq_gbis_eq_job2.log
mkdir OutFilesFromNAMD_job2
rm *job1*
cp * OutFilesFromNAMD_job2/.
tar czf OutFilesFromNAMD_job2.tar.gz OutFilesFromNAMD_job2
