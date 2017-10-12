[title]: - "Image Analysis of Human Brain - FreeSurfer Workflow From the OSG Connect Login Host"
[TOC]
 
## Overview

[FreeSurfer](http://freesurfer.net/) is a software package to analyze MRI images of human brain subjects. The OSG has developed a command line utility, `fsurf`, that simplifies `FreeSurfer` computation on the Open Science Grid (OSG).  Among its features:

* Handles job submission to OSG using appropriate flags for multi-core job slots
* Transfers image data to and from remote worker nodes
* Provides a complete pipeline to analyze an MRI image 

In this tutorial, we first describe the initial set up of `fsurf` on login node. Next, we will learn the usage of  `fsurf` to run image analysis on OSG and get the output files. 

![fig 1](https://raw.githubusercontent.com/OSGConnect/tutorial-FreeSurfer/master/Figs/freesurfer_image_from_net.png )

**Important note on data privacy**: The `fsurf` tool is *not* HIPPA compliant. (HIPPA, the Health Insurance Portability and Accountability Act, is a federal law written to protect personal medical information.) Therefore images must be anonymized and deidentified before they are uploaded to OSG servers as we discuss below.

##  Anonymize Images 

Since OSG resources are not HIPPA compliant, the MRI images must be deidentified and defaced on your local machine before being used.  You can use a local `FreeSurfer` installation to prepare your scans. First, on your local machine import into FreeSurfer your image by running

      $ recon-all -subject SUBJECT -i PATH_TO_MGZ_INPUT_FILE

Here, `recon-all` is the `FreeSurfer` command line tool, the argument `SUBJECT` is the name of the subject, and the argument `PATH_TO_MGZ_INPUT_FILE` is the  full path to the input file. The above command produces a single compressed image file `001.mgz`
under the directory `subjects/SUBJECT/mri/orig`. Now deface the image `001.mgz` to `SUBJECT_defaced.mgz` with the `mri_deface` command as follows,

      $ cd  ${FREESURFER_HOME}/average
      $ mri_deface ../subjects/SUBJECT/mri/orig/001.mgz  \
                   talairach_mixed_with_skull.gca  face.gca \
                   ${FREESURFER_HOME}/subjects/SUBJECT/mri/orig/SUBJECT_defaced.mgz

If the `mri_deface` program cannot find the needed `*.gca` files (the standard FreeSurfer parameter files), fetch and unzip them:

     $ cd ${FREESURFER_HOME}/average
     $ wget "http://stash.osgconnect.net/@freesurfer/face.gca"
     $ wget "http://stash.osgconnect.net/@freesurfer/talairach_mixed_with_skull.gca"


## Initial Setup
The tool `fsurf` is already installed on the OSG Connect login node. You just need to configure it in order to utilize `fsurf` on 
login node. First, ssh to the OSG Connect's login node:

     $ ssh username@login.osgconnect.net

and run

     $ fsurf-config

You should only need to run this command once in order to configure fsurf.

##  Process a Scan

A typical Freesurfer analysis runs autorecon1, autorecon2, and autorecon3 sequentially on MRI data.  All three steps are conveniently handled by `fsurf`. 

Get a sample MRI file by running

     curl -L -o MRN_3_defaced.mgz 'http://stash.osgconnect.net/+fsurf/MRN_3_defaced.mgz'

Now we do an analysis on `MRN_3_defaced.mgz`. In the file `MRN_3_defaced.mgz` the prefix `MRN_3` is the name of the subject.


     $ fsurf  --submit --subject MRN_3 

The `FreeSurfer` requires that the MRI file to be deidentified and defaced. The  `MRN_3__defaced.mgz` image is already deidentified and defaced, so say `y` to the following questions. 

     Has the MRI data been deidentified (This is required) [y/n]? y
     Has the MRI data been defaced (This is recommended) [y/n]? y

After typing `y` to the above two questions, `fsurf` creates and submits the workflow 

     Creating and submitting workflow
     Workflow submitted with an id of 20160119T100055-0600

The id of your workflow is `20160119T100055-0600`. The id is needed to check the status, remove and get the output of the workflow. 


###  List Workflows

Run the command below to get a list of workflows that you have submitted and their status:

     $ fsurf --list 
     Current workflows
     Subject    Workflow             Submit time          Cores Used      Status    
     test       20160119T100055-0600 10:00 01-19-2016     2               Running   


###  Get Outputs

Once a workflow is completed successfully, the status of the workflow should be `COMPLETED` as can be seen below

     $ fsurf --list 
     Current workflows
     Subject    Workflow             Submit time          Cores Used      Status    
     test       20160119T100055-0600 10:00 01-19-2016     2               COMPLETED   

Run the command below to get the output of the completed workflow `20160119T100055-0600`:
 
     $ fsurf --output --id 20160119T100055-0600

Depending on the computer resources available, a workflow will typically require 6-12 hours to complete.  The output will be saved as an archive in the current working directory: `test_output.tar.bz2` where test will be replaced by the subject name . You can extract all the files in the archive using: 

    $ tar -jxvf test_output.tar.bz2
 
 Similarly, you get the output of any completed  workflow with id `WorkflowID` 
 
     $ fsurf --output --id WorkflowID
     $ tar -jxvf <SubjectName>_output.tar.bz2

###  Remove Workflows

Run the following to remove an existing workflow:
   
    $ fsurf --remove --id WorkflowID

For example, to remove a running worflow with an id `20160119T100055-0600`, type

    $ fsurf --remove --id 20160119T100055-0600
    Workflow 20160119T100055-0600 removed successfully
    Waiting for running jobs to be removed...
    Jobs removed, removing workflow directory

This will not effect the files you have fetched previously.

## Getting Help 
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).



