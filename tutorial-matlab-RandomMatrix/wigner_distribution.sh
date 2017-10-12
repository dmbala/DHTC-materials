#!/bin/bash 
source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/current/init/bash
module load matlab/2014b
chmod +x wigner_distribution
./wigner_distribution $1 $2 

