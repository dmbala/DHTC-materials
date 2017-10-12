#!/bin/bash
tar xzf OutFilesFromNAMD_jobB0.tar.gz 
mv OutFilesFromNAMD_jobB0/*jobB0.restart* .

source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/5.6.2/init/bash
module load namd/2.9
namd2 namd_jobB1.conf > namd_jobB1.log
mkdir OutFilesFromNAMD_jobB1
cp * OutFilesFromNAMD_jobB1/.
tar czf OutFilesFromNAMD_jobB1.tar.gz OutFilesFromNAMD_jobB1
