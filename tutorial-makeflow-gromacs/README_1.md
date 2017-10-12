
[title]: - "Makeflow - Running GROMACS simulations in sequence of steps"
[TOC]
 
## Overview

[Makeflow](http://ccl.cse.nd.edu/software/makeflow/) is a workflow engine that handles a large number 
of jobs.  Makeflow is based on `Master/Workers` paradigm, in which the master controls the workers while the 
workers complete the tasks and transfer the data back to the master. In case of failure, the execution of 
jobs are  continued from where it stopped. The syntax of Makeflow is similar to `UNIX tool Make` that 
allows one to easily describe the job dependencies.  

<img src="https://raw.githubusercontent.com/OSGConnect/tutorial-makeflow-gromacs/master/Figs/MWFig.png" width="300px" height="250px" />
<img src="https://raw.githubusercontent.com/OSGConnect/tutorial-makeflow-gromacs/master/Figs/1cta_dimer_blackBG.png" width="300px" height="250px" />


In this tutorial, we learn how to run a sequence of jobs with Makeflow. The example is based on 
[GROMACS](http://www.gromacs.org/) application to run the molecular dynamics simulation of 1CTA dimer in water. 
To learn the basics of Makeflow, check the previous tutorial on 
[makeflow-quickstart](https://support.opensciencegrid.org/solution/articles/12000007096-makeflow-quickstart). 


## tutorial files

It is convenient to start with the `tutorial` command. In the command prompt, type

      $ tutorial makeflow-gromacs # Copies input and script files to the directory tutorial-makeflow-gromacs
 
This will create a directory `tutorial-makeflow-gromacs`. Inside the directory, you will see the following files
     
      1cta_nvt.tpr                         # GROMACS binary input file      
      gromacs_linear.makeflow              # Makeflow file that has the rules to run sequence of MD simulations. 
      submit_makeflow_to_local_condor.sh   # Script to execute the makeflow file as a local condor job 

`1cta_nvt.tpr` is the [input file for GROMACS in binary format](http://manual.gromacs.org/current/online/tpr.html). 
`gromacs_linear.makeflow` is the makeflow file that contains the make rules to run the MD simulations. 
`submit_makeflow_to_local_condor.sh` is the shell script to execute the makeflow file as local condor job. 


## Makeflow script to run sequence of MD simulations


<img src="https://raw.githubusercontent.com/OSGConnect/tutorial-makeflow-gromacs/master/Figs/gromacs_linear.png" width="350px" height="300px" />

As shown in the figure, there are four rules defined in the makeflow file. These rules are linearly ordered. Rule 1 is
the parent of Rule 2, Rule 2 is the parent of Rule 3, and so forth. The jobs execute one after another that starts from Rule 1 and ends at Rule 4.

The Rules 1, 2, and 3 are MD simulations that would run on OSG machines. Rule 4 cleans the files and it is local.


### Add additional job schedular options

Makeflow allows additional job schedular option to be added via the key word `BATCH_OPTIONS`.  Let us take a look at the first two lines of `gromacs_linear.makeflow`, 

     # Add additional condor expressions
     BATCH_OPTIONS = requirements = CVMFS_oasis_opensciencegrid_org_REVISION >= 5428

In Makeflow, the `BATCH_OPTIONS` keyword is used to add additional expressions and requirements. We would like 
to use GROMACS from [OASIS](https://support.opensciencegrid.org/support/solutions/articles/5000634394-accessing-software-using-distributed-environment-modules), so we require the recently updated versions are available with the requirement - `CVMFS_oasis_opensciencegrid_org_REVISION >= 5428`. 

### Use the GROMACS package from OASIS on OSG machines.

No need to transfer the packages that already exists as distributed environmental modules, known as OASIS. To see 
how this is done,  let us take a look at the Rule 1 in `gromacs_linear.makeflow`,

    # Rule 1. Outputfile = 1cta_nvt_mdrun1.cpt, Inputfile = 1cta_nvt.tpr (Executables from OASIS) 
    1cta_nvt_mdrun1.cpt: 1cta_nvt.tpr
        module load gromacs/5.0.5; gmx mdrun -ntmpi 1 -ntomp 1 -nt 1 -s 1cta_nvt.tpr -deffnm 1cta_nvt_mdrun1 -nsteps 100

In the above make rule, `1cta_nvt_mdrun1.cpt` is the output and `1cta_nvt.tpr` is the input. There are two command 
executions. The first command execution, `module load gromacs/5.0.5`, loads GROMACS from OASIS. The next
command execution, runs the MD simulation using GROMACS. 

The second command calls gmx (GROMACS) to run mdrun for the 
input file `1cta_nvt.tpr`. The arguments ntmpi, ntomp and nt are related to number of mpi threads, number of 
openMP threads and total number of threads, respectively.  Check [GROMACS manual](http://manual.gromacs.org/current/online) to understand the details of all the arguments.  The argument `nsteps` controls the number 
of MD steps. Here, we choose small number of steps 
for simplicity, feel free to experiment with this number as you like.

Rules 2 and 3 are similar to Rule 1. In Rule 2, the checkpoint file `1cta_nvt_mdrun1.cpt` from Rule 1 serves as 
the input. In Rule 3, the checkpoint file `1cta_nvt_mdrun2.cpt` from Rule 2 serves as the input. This is how the job 
dependencies are built in the makeflow file.

### Local Rule to clean up the files

Let us take a look at Rule 4 in `gromacs_linear.makeflow`, 

    # Rule 4. Runs locally. Collects all the output files under the directory Output. 
    list_of_output_files.txt: 1cta_nvt_mdrun1.cpt 1cta_nvt_mdrun2.cpt 1cta_nvt_mdrun3.cpt
      LOCAL  mkdir -p Output; mv *.edr Output/.; mv *.gro Output/. ; mv *.log Output/.; mv *.trr Output/; ls Output > list_of_output_files.txt

Rule 4 is the last step in the workflow and is executed locally. This job waits for other jobs to complete,
 moves certain files to the output directory `Output`, and stores the list of moved files 
in a file `list_of_output_files.txt`. 

## Execute the Makeflow script as a local condor job

Now let us execute the workflow, 

     $ submit_makeflow_to_local_condor.sh gromacs_linear.makeflow

This shell command executes the makeflow file `gromacs_linear.makeflow` as a local condor job. 

Further details on the condor local jobs are in the tutorial 
on [makeflow-quickstart](https://support.opensciencegrid.org/solution/articles/12000007096-makeflow-quickstart).

Check the job status

    $ condor_q username -wide

Once the jobs completed, you will see a directory `Output` that contains GROMACS output files such 
as  .gro, .edr, .log files. 

## Getting Help
For technical questions about Makeflow,  contact [Cooperative Computing Lab (cclab)](http://ccl.cse.nd.edu/software/help/).
For general assistance or questions related to running the jobs on OSG, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).

