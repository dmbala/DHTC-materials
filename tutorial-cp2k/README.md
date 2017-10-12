[title]: - "Electronic Structure Calculations with CP2K"
[TOC]
   
## Overview
[CP2K](http://www.cp2k.org/) is an open source program to perform atomistic and molecular simulations of solid state, liquid, molecular, and biological systems. It provides a general framework for different methods such as e.g., density functional theory (DFT) using a mixed Gaussian and plane waves approach (GPW) and classical pair and many-body potentials.

## Quick steps to run CP2K

	$ tutorial cp2k                 # Copies input and script files to the directory "tutorial-cp2k".
	$ cd tutorial-cp2k              # Takes you to the directory "tutorial-cp2k".
	$ condor_submit cp2k.submit # Submits the condor job script file "cp2k_run.submit".

After few minutes, CP2K outputs are generated in the directory `tutorial-cp2k`. In the following sections, we will discuss the details of preparing the input and job script files to run the CP2K simulations.

## CP2K tutorial files

In the command prompt, type

	$ tutorial cp2k # Copies the input and script files to the directory tutorial-cp2k.

This will create a directory `tutorial-cp2k`. Inside the directory, you will see the following files

	cp2k.submit               # Condor job submission script file.
	cp2k.sh                   # Job execution script file.
	cs_cell_opt_direct_lbfgs.inp  # Input configuration file  for running the cp2k simulation. 
	
Here, `cp2k_run.submit` and `cp2k_run.sh` are the script files related to job submission and the file 
`cs_cell_opt_direct_lbfgs.inp` is the input file for the CP2K simulation. The details regarding the 
preparation of the input file for CP2K are available at the CP2K website.

## Job execution and submission files

The file `cp2k.submit` is the condor description file.  Please refer to the Quickstart tutorial to learn 
about the key words in the script file. Here, we will discuss the condor file transfer mechanism. The option `transfer_input_files`  specifies what input files are transferred from the login machine 
(where you log in and submit the jobs) to the remote worker machine (where the jobs are being executed). In 
the `cp2k.submit` file, the option

	transfer_input_files = cs_cell_opt_direct_lbfgs.inp # Name of the input file transferred to the worker machine.

means that the listed file `cs_cell_opt_direct_lbfgs.inp`  is transferred from the login machine to the 
worker machine.  Similarly, we can specify the output files from the worker machine to Midway by adding the 
following lines in the condor job submission script file - `cp2k.submit`.

	transfer_output_files = file1.out, file2.out, file3.out ... etc # List of output files separated by commas.
	should_transfer_files=Yes          # Key word to activate the file transfer
	when_to_transfer_output = ON_EXIT  # After the job execution is finished
	
	 
For vanilla universe jobs, all the output files are transferred  automatically (the current example runs the job in the vanilla universe). In other universe types, for example  grid universe, the user needs to specify the list of output files. 
	
The script file `cp2k.sh` includes information about loading the module and the job execution commands:

	#!/bin/bash
	source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/5.6.2/init/bash # Reads and executes the bash file located in the init directory.
	module load cp2k  # Sets up cp2k module
	cp2k.x cs_cell_opt_direct_lbfgs.inp > cs_cell_opt_direct_lbfgs.out   # Runs the CP2K program
	
## Running the simulation
	 
To run the simulation, type
	
	$ condor_submit cp2k.submit # Submit the condor job script "cp2k_run.submit"
	 
Now you have submitted the CP2K simulation on the open science grid. The present job should be finished quickly (in less than an hour). You can check the status of the submitted job by typing
	
	$ condor_q username # The status of the job is printed on the screen. Here, username is your login name.
	 
After the simulation is completed, you will see the output files from CP2K including the main output file, trajectory files and restart files in your work directory.
	
## Getting Help
For assistance or questions, please email the OSG User Support team  at <mailto:user-support@opensciencegrid.org> or visit the [help desk and community forums](http://support.opensciencegrid.org).
