#!/bin/bash
source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/5.6.2/init/bash
module load namd/2.9
namd2 namd_jobA0.conf > namd_jobA0.log
mkdir OutFilesFromNAMD_jobA0
cp * OutFilesFromNAMD_jobA0/.
tar czf OutFilesFromNAMD_jobA0.tar.gz OutFilesFromNAMD_jobA0
