
[title]: - "GAMESS"
[TOC]
 
## Overview

[GAMESS](http://www.msg.chem.iastate.edu/gamess/) (General Atomic and Molecular Electronic Structure System)
is a quantum chemistry package. In this tutorial, we learn how to run GAMESS calculation on the OSG. Our example 
system is CH2 molecule.  

## GAMESGAMESSS tutorial files

Let us start with the `tutorial` command. In the command prompt, type
	 $ tutorial gamess # Copies input and script files to the directory tutorial-gamess.
 
This will create a directory `tutorial-gamess`. Inside the directory, you will see the following files

     ch2_rhf_opt.inp             # Input file for gamess calculation (RHF calculation for CH2 molecule)
     gamess_condor.sh            # Wrapper script to run the calculation 
     gamess_condor.submit        # HTCondor job description file 


Here, `ch2_rhf_opt.inp` is the input file, `gamess_condor.sh` is the job execution shell script, and 
`gamess_condor.submit` is the job submission file. 


## Job execution and submission files

Let us take a look at `gamess_job.submit` file: 

    # The UNIVERSE defines an execution environment for HTcondor jobs. You will almost always use VANILLA. 
    Universe = vanilla  
    # EXECUTABLE is the program to run. It is a good practice to create a shell script to "wrap" your actual work. 
    Executable = gamess_condor.sh

    # Send the input file along with the job
    transfer_input_files = ch2_rhf_opt.inp
    should_transfer_files=Yes
    when_to_transfer_output = ON_EXIT

    # Hardware requests 
    request_cpus = 1
    request_memory = 2GB
    request_disk   = 1GB

    # output and error from your job 
    output        = job.out
    error         = job.error

    # The status, success, and resource consumption of the job is written in the log file
    log           = job.log

    # Checks the distributed module is available on the remote site 
    requirements = (HAS_CVMFS_oasis_opensciencegrid_org =?= TRUE)

    # QUEUE is the "start button". It sends the above lines to the queue. 
    Queue 


As mentioned in the job description file, the executable is `gamess_condor.sh` which has the following information 

    #!/bin/bash

    # loads the gamess module 
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

## Running the simulation

We submit the job using `condor_submit` command as follows

	$ condor_submit gamess_condor.submit //Submit the condor job script "gamess_condor.submit"

Now you have submitted the GAMESS calculation of CH2 on the OSG.  The present job should be finished quickly (less than an hour). You can check the status of the submitted job by using the `condor_q` command as follows

	$ condor_q username  # The status of the job is printed on the screen. Here, username is your login name.

After the simulation is completed, you will see the following output files 

     $ ls
     ch2_rhf_opt.inp  gamess_condor.sh      job.error  job.out               README.md
     ch2_rhf_opt.log  gamess_condor.submit  job.log    local_scratch.tar.gz

The output files are ch2_rhf_opt.log and local_scratch.tar.gz.  To check the gamess 
calculation, see the total energy from the output file ch2_rhf_opt.log

    $ grep "TOTAL ENERGY=" ch2_rhf_opt.log

           TOTAL ENERGY=    -36.8001044978
           TOTAL ENERGY=    -37.2380397827


## Getting Help
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).
