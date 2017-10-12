#!/bin/bash

EXPECTED_ARGS=1

if [ $# -ne $EXPECTED_ARGS ]; then
  echo "Usage: R-wrapper.sh file.R"
  exit 1
else
  source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/current/init/bash
  module load R
  module load libgfortran
  Rscript $1
fi
