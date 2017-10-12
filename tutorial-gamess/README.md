
[title]: - "GAMESS"
[TOC]
 
## Overview

[GAMESS](http://www.msg.chem.iastate.edu/gamess/) (General Atomic and Molecular Electronic Structure System)
is 
a quantum chemistry package. In this tutorial, we learn how to run GAMESS calculation on the OSG. Our example 
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


