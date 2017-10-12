#!/bin/bash

set -e

TOPDIR=`pwd`

# generate the dax
export PYTHONPATH=`pegasus-config --python`
./dax-generator-namdEq-sequential.py 

# create the site catalog

chmod +x ./sites-generator.bash
./sites-generator.bash

# plan and submit the  workflow
pegasus-plan \
    --conf pegasusrc \
    --sites condorpool \
    --dir $PWD/workflows \
    --output-site local \
    --dax dax.xml \
    --submit

