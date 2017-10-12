
[title]: - "Makeflow - Running GROMACS simulations in sequence of steps"
[TOC]
 
## Overview

[Makeflow](http://ccl.cse.nd.edu/software/makeflow/) is a workflow engine that handles a large number 
of jobs.   It is based on `Master/Workers` paradigm. A master process monitors and controls the 
workers while the workers complete the assigned tasks.  Makeflow rules are easy to pick up since its syntax is 
similar to UNIX tool `Make`. 


<tr>
 <td> <img src="https://raw.githubusercontent.com/OSGConnect/tutorial-makeflow-gromacs/master/Figs/MWFig.png" width="200px" height="150px" /> </td> 
 <td> <img  width="100px" height="0px" /> </td> 
 <td> <img src="https://raw.githubusercontent.com/OSGConnect/tutorial-makeflow-gromacs/master/Figs/1cta_dimer_blackBG.png" width="170px" height="120px" /> </td> `
</tr>  
<br> </br>

In this tutorial, we learn how to run a sequence of jobs with Makeflow. We consider an example of running 
molecular dynamics simulation of 1CTA dimer in water using [GROMACS](http://www.gromacs.org/) package. 
To learn the basics of Makeflow, check the previous tutorial on 
[makeflow-quickstart](https://support.opensciencegrid.org/solution/articles/12000007096-makeflow-quickstart). 

## Tutorial files

It is convenient to start with the `tutorial` command. In the command prompt, type

      $ tutorial makeflow-gromacs 
 
This will create a directory `tutorial-makeflow-gromacs`. Inside the directory, you see following files
    
      $ ls tutorial-makeflow-gromacs 
      1cta_nvt.tpr                         
      gromacs_linear.makeflow               
      submit_makeflow_to_local_condor.sh   

Here, `1cta_nvt.tpr` is an [input file for GROMACS in binary format](http://manual.gromacs.org/current/online/tpr.html),  
`gromacs_linear.makeflow` is a Makeflow file, and 
`submit_makeflow_to_local_condor.sh` is a shell script to execute makeflow as a local condor job. 


## Makeflow script to run sequence of MD simulations


<img src="https://raw.githubusercontent.com/OSGConnect/tutorial-makeflow-gromacs/master/Figs/gromacs_linear.png" width="350px" height="300px" />


As shown in Figure, there are four rules in  `gromacs_linear.makeflow`. The jobs run in a sequential fashion.  Rule 1 is the parent of Rule 2, Rule 2 is the parent of Rule 3, and so on.  Rules 1, 2, and 3 are MD simulations that would run 
on OSG machines. Rule 4 runs locally and cleans up the files. 

## Execute Makeflow script as a local condor job

Now let us execute the workflow, 

     $ submit_makeflow_to_local_condor.sh gromacs_linear.makeflow

This shell command executes the makeflow file `gromacs_linear.makeflow` as a local condor job. 

Further details on the condor local jobs are given in the tutorial 
on [makeflow-quickstart](https://support.opensciencegrid.org/solution/articles/12000007096-makeflow-quickstart).

Check the job status

    $ condor_q username -wide

When all the jobs finished, you will see `Output` directory that contains GROMACS output files such 
as  .gro, .edr, .log files. 


## A closer look at the Makeflow script

Let us take a closer look at the Makelfow file `gromacs_linear.makeflow` and understand how GROMACS commands are available on remote machines. 

### Using GROMACS from OASIS. 

GROMACS is available in [OASIS](https://support.opensciencegrid.org/support/solutions/articles/5000634394-accessing-software-using-distributed-environment-modules) as a distributed module. We want to make sure 
that OASIS is accessible on a remote machine. This is done via the  key word `BATCH_OPTIONS` in 
Makeflow. Let us take a look at the line in `gromacs_linear.makeflow`, 

     BATCH_OPTIONS = requirements = CVMFS_oasis_opensciencegrid_org_REVISION >= 5428

which sets the HTCondor requirement that an updated version of OASIS is available on a remote OSG machine.

### Executing GROMACS simulation

To use GROMACS on a remote machine, we added the requirement of OASIS availability 
in `BATCH_OPTIONS`. We also need to do `module load GROMACS` before 
executing the GROMACS commands.  Let us take a look at Rule 1 in `gromacs_linear.makeflow`,

    # Rule 1. Outputfile = 1cta_nvt_mdrun1.cpt, Inputfile = 1cta_nvt.tpr (Executables from OASIS) 
    1cta_nvt_mdrun1.cpt: 1cta_nvt.tpr
        module load gromacs/5.0.5; gmx mdrun -ntmpi 1 -ntomp 1 -nt 1 -s 1cta_nvt.tpr -deffnm 1cta_nvt_mdrun1 -nsteps 100

In the above rule, `1cta_nvt_mdrun1.cpt` is the output and `1cta_nvt.tpr` is the input. There are two command 
executions. The first command execution, `module load gromacs/5.0.5`, loads GROMACS from OASIS. The next
command execution, runs the MD simulation using GROMACS command `gmx`. 

The arguments ntmpi, ntomp and nt are related to number of mpi threads, number of 
openMP threads and total number of threads, respectively.  Check [GROMACS manual](http://manual.gromacs.org/current/online) to understand the details of all the arguments.  The argument `nsteps` controls the number 
of MD steps. Here, we chose small number of steps (100) for a quick demonstration. 

Rules 2 and 3 are similar to Rule 1, except they use the check point files. For example, the checkpoint 
file `1cta_nvt_mdrun1.cpt` is produced from Rule 1 and it is used  as an input for Rule2. Similarly, the 
checkpoint file `1cta_nvt_mdrun2.cpt` from Rule 2 is used by Rule 3. 

Rule 4 is the last step in the workflow and is executed locally. It waits for other jobs to complete, moves 
certain files to `Output` directory, and stores the list of moved files in a file `list_of_output_files.txt`.

## Getting Help
For technical questions about Makeflow,  contact [Cooperative Computing Lab (cclab)](http://ccl.cse.nd.edu/software/help/).
For general assistance or questions related to running the jobs on OSG, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).

