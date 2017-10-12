#!/bin/bash
module load namd/2.9
wget http://stash.osgconnect.net/+username/par_all27_prot_lipid.inp
namd2 ubq_gbis_eq.conf > namdoutput_using_stash.dat




