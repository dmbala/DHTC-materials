#!/bin/bash
source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/5.6.2/init/bash
module load namd/2.9
namd2 namd_jobB0.conf > namd_jobB0.log
mkdir OutFilesFromNAMD_jobB0
cp * OutFilesFromNAMD_jobB0/.
tar czf OutFilesFromNAMD_jobB0.tar.gz OutFilesFromNAMD_jobB0
