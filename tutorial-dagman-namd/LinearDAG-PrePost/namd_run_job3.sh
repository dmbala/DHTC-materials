#!/bin/bash
tar xzf OutFilesFromNAMD_job2.tar.gz 
mv OutFilesFromNAMD_job2/*job2.restart* .

module load namd/2.9
namd2 ubq_gbis_eq_job3.conf > ubq_gbis_eq_job3.log
mkdir OutFilesFromNAMD_job3
rm *job2*
cp * OutFilesFromNAMD_job3/.
tar czf OutFilesFromNAMD_job3.tar.gz OutFilesFromNAMD_job3
