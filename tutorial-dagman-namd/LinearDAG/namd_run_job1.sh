#!/bin/bash
tar xzf OutFilesFromNAMD_job0.tar.gz 
mv OutFilesFromNAMD_job0/*job0.restart* .

module load namd/2.9
namd2 ubq_gbis_eq_job1.conf > ubq_gbis_eq_job1.log
mkdir OutFilesFromNAMD_job1
rm *job0*
cp * OutFilesFromNAMD_job1/.
tar czf OutFilesFromNAMD_job1.tar.gz OutFilesFromNAMD_job1
