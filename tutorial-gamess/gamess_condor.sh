#!/bin/bash

# first load the gamess module 
  module load gamess                    

# create a local_scratch directory
  mkdir -p local_scratch
# define the SCRATCH environmental variable for the GAMESS calculations
  export SCRATCH=$PWD/local_scratch

# run the gamess job
  rungms  ch2_rhf_opt.inp > ch2_rhf_opt.log

# compress the local_scratch directory
  tar czf local_scratch.tar.gz local_scratch
# remove local_scratch directory as it may have huge files sometime
  rm -r local_scratch 
