[title]: - "NAMD with input data from Stash using HTTP"

[TOC]

## View Stash data using the web
Stash allows you to access files using your web browser.  In order to do
this, you'll need to put your file in `~/public`or `~/data/public` (the two locations 
point to the same directory). Any file or directory that is placed 
here will be made available in the Stash webserver.  Let's make a file
available using the Stash webserver:

	$ cd ~/public
	$ echo "This is served over the web" > web-file

Now go to `http://stash.osgconnect.net/+username/` in your browser.  You should
see the file in the listing.  Clicking on the file should give you the contents.

## Using data on Stash in compute jobs

Let us do an example calculation to understand the use of Stash and how we download 
the data from the web. We will peform a  molecular dynamics simulation of a small 
protein in implicit water. To get the necessary files, we use the `tutorial` command on 
OSG Connect.

Log in to OSG Connect:

	$ ssh username@login.osgconnect.net

Type:

	$ tutorial stash-namd
	$ cd ~/tutorial-stash-namd

*Aside*: [NAMD](http://www.ks.uiuc.edu/Research/namd/) is a widely used molecular dynamics simulation program. It lets users specify a molecule in some initial state and then observe its time evolution subject to forces. Essentially, it lets you go from a specifed molecular [structure](http://en.wikipedia.org/wiki/Superoxide_dismutase#mediaviewer/File:Superoxide_dismutase_2_PDB_1VAR.png) to a [simulation](https://www.youtube.com/watch?v=mk3cLd9PUPA&list=PL418E1C62DD9FC8BA&index=1) of its behavior in a particular environment.  It has been used to study polio eradication, similations of graphene, and studies of biofuels.

You should see the following files in the directory:

	$ ls
	namd_stash_run.submit #HTCondor job submission script file.
	namd_stash_run.sh #Job execution script file.
	ubq_gbis_eq.conf #Input configuration for NAMD.
	ubq.pdb #Input pdb file for NAMD.
	ubq.psf #Input file for NAMD.
	par_all27_prot_lipid.inp #Parameter file for NAMD.

The file `par_all27_prot_lipid.inp` is the parameter file and is required for 
the NAMD simulations. The parameter file is common data file for the NAMD
simulations. 

	mv par_all27_prot_lipid.inp ~/public/.  

You can view the parameter file using your web browser by going to 
`http://stash.osgconnect.net/+yourusername`.

Now we want the parameter file available on the execution (worker) machine when the 
simulation starts to run. As mentioned earlier, the data on the Stash is available to 
the execution machines. This means the execution machine can transfer the data from 
Stash as a part of the job execution. So we have to script this in the job execution 
script. 

You can see that the job script `namd_stash_run.sh` has the following lines:

	$ cat namd_stash_run.sh
	#!/bin/bash 
	source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/5.6.2/init/bash 
	module load namd/2.9  
	wget http://stash.osgconnect.net/+username/par_all27_prot_lipid.inp  
	namd2 ubq_gbis_eq.conf  

In the above script, you will have to insert your `username` in URL address. The
parameter file located on Stash is downloaded using the #wget# utility.  

Now we submit the NAMD job:

	$ condor_submit namd_stash_run.submit 

Once the job completes, you will see a non-empty `job.out.0` file, the standard output (`stdout`) from the job.

	$ tail job.out.0
	
	WallClock: 6.084453  CPUTime: 6.084453  Memory: 53.500000 MB
	Program finished.
	

The above lines indicate the NAMD simulation was successful. 


## Key Points
- [x] Your Stash data is located at `~/stash` and `~/public` on login.osgconnect.net. 
- [x] Data on Stash can be accessed by jobs running on compute nodes in the OSG. 


## Getting Help
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).
