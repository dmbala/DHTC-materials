[title]:- Compute the eigenvalues of a matrix using Octave
[TOC]

## Overview
In the following example, we generate a random matrix and calculate the
eigenvectors of the matrix using Octave.

## Setup

### Get tutorial files
We get the needed files via the `tutorial` command by typing the following:

	$ tutorial octave
	Installing octave (osg)...
	Tutorial files installed in ./tutorial-octave.
	Running setup in ./tutorial-octave...

All needed the files are located in the `tutorial-octave/` directory

	$ cd tutorial-octave
	$ ls
	ex1_matrix.octave    # exercise 1
	ex2_matrix.octave    # exercise 2
	log/                 # directory where the outputs are written
	octave.submit        # job description file for HTCondor
	octave-wrapper.sh    # Wrapper script
	README.md            # Readme file

In the job description file, we execute the wrapper script. The wrapper script
contains the information about the tasks.  

## Job submission
We submit the job on the grid using the condor submit command

	$ condor_submit octave.submit
	Submitting
	job(s)....................................................................................................
	100 job(s) submitted to cluster 252466.

## Job monitoring
The  ID for the above job is 252466. Note that we submitted 100 jobs by means of
the keyword `Queue 100` in the octave.submit file. As a result, we have 100 jobs
with ID's  252466.0, 252466.1, 252466.2, and so on. You can check the status of the
jobs 

	$ condor_q 252446

or 

	$ condor_q username

## Job outputs
Once the job finished, the output files are in the log directory. The
eigenvalues are listed in `octave.out.JOBID` files.

## Getting Help
For assistance or questions, please email the OSG User Support team  at <mailto:user-support@opensciencegrid.org> or visit the [help desk and community forums](http://support.opensciencegrid.org).
