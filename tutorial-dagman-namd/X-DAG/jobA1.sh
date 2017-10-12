#!/bin/bash
cp A1confile namd_jobA1.conf
tar xzf OutFilesFromNAMD_jobA0.tar.gz 
mv OutFilesFromNAMD_jobA0/*jobA0.restart* .
rm OutFilesFromNAMD_jobA0/*
rmdir OutFilesFromNAMD_jobA0 OutFilesFromNAMD_jobB0.tar.gz

source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/5.6.2/init/bash
module load namd/2.9
namd2 namd_jobA1.conf > namd_jobA1.log
mkdir OutFilesFromNAMD_jobA1
cp * OutFilesFromNAMD_jobA1/.
tar czf OutFilesFromNAMD_jobA1.tar.gz OutFilesFromNAMD_jobA1
