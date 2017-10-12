#!/bin/bash
config_file=$1
ligand_file=$2
out_pdbqt=$3
log_file=$4

module load autodock 
/cvmfs/oasis.opensciencegrid.org/osg/modules/autodock/4.2.6/vina --config $config_file --ligand $ligand_file --out $out_pdbqt --log $log_file
