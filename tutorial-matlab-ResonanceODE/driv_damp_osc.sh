#!/bin/bash
source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/current/init/bash
module load matlab/2014b
chmod +x driv_damp_osc
./driv_damp_osc $1
