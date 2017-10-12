[title]: - "Image Analysis of Human Brain - Running FreeSurfer Workflows from Your System"
[TOC]
 
## Overview

[FreeSurfer](http://freesurfer.net/) is a software package to analyze MRI images of human brain subjects. The OSG has developed a command line utility, `fsurf`, that simplifies `FreeSurfer` computation on the Open Science Grid (OSG).  Among its features:

* Handles job submission to OSG using appropriate flags for multi-core job slots
* Transfers image data to and from remote worker nodes
* Provides a complete pipeline to analyze an MRI image 


In this tutorial, we first describe the initial set up of `fsurf` on your laptop (or desktop). Next, we will learn the usage of  `fsurf` to run image analysis from your laptop. 

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


##  Setup

Set up `fsurf` on your laptop (linux/unix/MacOS X OS system) by downloading the script using the `curl` command. You need to install python.2.7 on your laptop (or desktop) to run fsurf. Open a terminal window and then run:

      curl -L -o fsurf 'http://stash.osgconnect.net/+fsurf/fsurf'
      chmod +x fsurf 

While using the local laptop or desktop version of fsurf, you  specify `username` using the `--user` argument and the `password` 
using `--password`.  For example,  

      ./fsurf --submit --subject MRN_3 --user myuser --password mypassword

the argument `myuser` is your username and `mypassword` is your password for your fsurf account.  If you don't have a fsurf password, open a ticket requesting an account [here](https://support.opensciencegrid.org/support/tickets/new). 

##  Process a Scan

A typical Freesurfer analysis runs autorecon1, autorecon2, and autorecon3 sequentially on MRI data.  All three steps are conveniently handled by `fsurf`. 

Get a sample MRI file by running

     curl -L -o MRN_3_defaced.mgz 'http://stash.osgconnect.net/+fsurf/MRN_3_defaced.mgz'

the file `MRN_3_defaced.mgz` is the defaced sample file. 

Now we do an analysis on `MRN_3_defaced.mgz`. In the file `MRN_3_defaced.mgz` the prefix `MRN_3` is the name of the subject.


     $ ./fsurf  --submit --subject MRN_3 --user myuser --password mypassword

The `FreeSurfer` requires that the MRI file to be deidentified and defaced. The `MRN_3_defaced.mgz` image is already deidentified and defaced, so say `y` to the following questions. 

     Has the MRI data been deidentified (This is required) [y/n]? y
     Has the MRI data been defaced (This is recommended) [y/n]? y

After typing `y` to the above two questions, `fsurf` creates and submits the workflow 

     Creating and submitting workflow
     Workflow submitted with an id of 20160119T100055-0600

The id of your workflow is `20160119T100055-0600`. The id is needed to check the status, remove and get the output of the workflow. 


##  List Workflows

Run the command below to get a list of workflows that you have submitted and their status:

     $ ./fsurf --list --user myuser --password mypassword
     Current workflows
     Subject    Workflow             Submit time          Cores          Status
     test       97                   10:00 01-19-2016     2               Running   


###  Getting Outputs

Once a workflow is completed successfully, the status of the workflow should be `COMPLETED` as below

     $ ./fsurf --list --user myuser --password mypassword
     Current workflows
     Subject    Workflow             Submit time          Cores           Status    
     test       97                   10:00 01-19-2016     2               COMPLETED   

Run the command below to get the output of the completed workflow `20160119T100055-0600`:
 
     $ ./fsurf --output --id 97 --user myuser --password mypassword

Depending on the computer resources available, a workflow will typically require 6-12 hours to complete.  The output will be saved as an archive in the current working directory: `test_output.tar.bz2` where test will be replaced by the subject name . You can extract all the files in the archive using: 

    $ tar -jxvf test_output.tar.bz2
 
 Similarly, you get the output of any completed  workflow with id `WorkflowID` 
 
     $ ./fsurf --output --id WorkflowID
     $ tar -jxvf <SubjectName>_output.tar.bz2

##  Remove Workflows

Run the following to remove an existing workflow:
   
    $ ./fsurf --remove --id WorkflowID

For example, to remove a running worflow with an id `56`, type

    $ ./fsurf --remove --id 56
    Workflow removed

This will not effect the files you have downloaded already.




## Getting Help 
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).



