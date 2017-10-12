#!/bin/bash
source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/current/init/bash
module load matlab/2014b
chmod +x SA_Opt
./SA_Opt $1
