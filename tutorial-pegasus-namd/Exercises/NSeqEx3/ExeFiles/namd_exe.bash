#!/bin/bash

echo "System Information"
echo -n "HOSTNAME=  "
hostname
echo -n "UnixName=  "
uname -a
echo -n "OSsystem=   "

if [ -f /etc/lsb-release ]; then
        osysname=$(lsb_release -s -d)
elif [ -f /etc/debian_version ]; then
        osysname="Debian $(cat /etc/debian_version)"
elif [ -f /etc/redhat-release ]; then
        osysname=`cat /etc/redhat-release`
else
        osysname="$(uname -s) $(uname -r)"
fi

echo " $osysname " 


echo OSG_WN_TMP: $OSG_WN_TMP
echo OSG_JOB_CONTACT: $OSG_JOB_CONTACT
echo OSG_DATA: $OSG_DATA
echo OSG_APP: $OSG_APP
echo OSG_GRID: $OSG_GRID
echo OSG_HOSTNAME: $OSG_HOSTNAME
echo OSGVO_CMSSW_Path: $OSGVO_CMSSW_Path
echo OSG_SITE_NAME: $OSG_SITE_NAME
echo OSGVO_CPU_MODEL: $OSGVO_CPU_MODEL
echo LD_LIBRARY_PATH: $LD_LIBRSRY_PATH


inputfile=$1
outputfile=$2
restartfile=$3

outputdir=$1_dir

if [ $# -eq 3 ]; then 

mkdir -p UnzipRestart; cd UnzipRestart; mv ../$restartfile .; tar xzf $restartfile; mv ubq_gbis*/*.restart.* ../.
cd ../; rm -rf UnzipRestart

fi

source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/5.6.2/init/bash
module load namd/2.9
/cvmfs/oasis.opensciencegrid.org/osg/modules/namd-2.9/namd2 $inputfile > $inputfile.log

mkdir -p $outputdir
cp $inputfile.log $outputdir/.
cp $inputfile.dcd $outputdir/.
cp $inputfile.restart.xsc $outputdir/.
cp $inputfile.restart.coor $outputdir/.
cp $inputfile.restart.vel $outputdir/.

tar czf $outputfile $outputdir

