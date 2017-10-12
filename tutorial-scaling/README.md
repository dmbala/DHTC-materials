Scaling up to more resources
==================================================

Intro
-----
For this tutorial, we'll scale up the number of jobs we submit onto the grid. We'll target specific resources both directly and by considering restrictions.

Setup
-----
First let's create a new space for this tutorial. You can also run *tutorial scaling* to create the tutorial directory for you.
	% ssh login01.osgconnect.net
	$ mkdir -p osg-scaling
	$ cd osg-scaling
Steering jobs to a Campus Grid
------------------------------
If you have a Campus Grid connected into OSG Connect, you can, for example, steer jobs by matching against hostname. In this example, we match against any hostname that starts with "uc" in the University of Chicago Campus Grid. 

First things first, we need to create a job. Let's re-use the "short.sh" script from the Quickstart tutorial. The short.sh script should look like the following:
	#!/bin/bash
	# short.sh: a short discovery job
	printf "Start time: "; /bin/date
	printf "Job is running on node: "; /bin/hostname
	printf "Job running as user: "; /usr/bin/id
	printf "Job is running in directory: "; /bin/pwd
	echo
	echo "Working hard..."
	sleep ${1-15}
	echo "Science complete!"

To steer our job to the University of Chicago Campus Grid, we'll add a "Requirements" section. Requirements match against an HTCondor ClassAd (classified ad), which describes the capabilities of an execute node. We'll call the job submission file campus.submit: 
	Universe = vanilla
	
	Executable = short.sh
	Arguments = 5 # to sleep 5 seconds
	
	Error = log/campus.err.$(Cluster)-$(Process)
	Output = log/campus.out.$(Cluster)-$(Process)
	Log = log/campus.log.$(Cluster)
	
	Requirements = (regexp("^uc*", TARGET.Machine, "IM") == True)
	Queue 25

Steering jobs to OSG
--------------------
In some cases, you might want to restrict your job to only run at certain OSG sites. Let's first create the Python code in our file SDE.py:
	#!/bin/env python
	# SDE.py: calculate the transition rate of a particle in a well
	# COMMAND TO RUN: ./SDE-script.py $Temp $Numt
	# https://github.com/patrickmalsom/SDE
	
	from math import sqrt     # import sqrt function
	from sys import argv      # command line arguments
	import random  # random number library
	from os import urandom    # used to seed the random number generator (RNG)
	from time import clock    # time the run
	start = clock()           # start timing
	
	# Define the constants
	Temp=float(argv[1])       # configurational Temperature
	Numt=int(argv[2])         # total number of time steps. Numt=500000 takes ~ 1 second
	dt=0.001                  # time step
	xstart=1.0                # starting position
	basin=xstart              # value of the last visited basin
	trans=0                   # number of transitions completed
	pref=sqrt(2*Temp*dt)      # prefactor for the thermal weight
	trans=0                   # number of transitions completed
	basin=xstart              # value of the last visited basin
	xold=xstart;              # initialize the starting point
	
	# define the force ( for this example V(x)=(x^2-1)^2 )
	def F(x): return 4*x*(1-x*x)
	for i in range(Numt):
	    # Perform the next step. Uses a gaussian random number at each step.
	    xnew=xold+dt*F(xold)+pref*random.gauss(0,1);
	    # Test to see if a transition has occured
	    # Assumes: abs(xnew-xold) < 1
	    if abs(xnew) > 1.0 and basin * xnew < 0.0 :
	        # True: incriment transition counter
	        trans=trans+1;
	        # change the last visited basin
	        if xnew > 0.0 :
	            basin=1.0;
	        else:
	            basin=-1.0;
	    # update xold
	    xold=xnew;
	elapsed = (clock() - start); # stop timing
	
	# Print the results to std out
	print "Temp=%f \t Trans=%d, Elapsed time:%f" % (Temp,trans,elapsed)
And let's create a submit file for that, called osg.submit. Note the new Requirement line for steering jobs to OSG:
	Universe = vanilla
	
	Executable = SDE.py
	Arguments = 0.25 500000
	
	Error = log/osg.err.$(Cluster)-$(Process)
	Output = log/osg.out.$(Cluster)-$(Process)
	Log = log/osg.log.$(Cluster)
	
	REQUIREMENTS = IS_GLIDEIN == True
	
	Queue 25
Submitting anywhere.
-------------------
Now, if we can remove this requirement from our job, we can submit anywhere. Let's give it a shot with our python code in SDE.py:

Of course we'll need to create a submit file, too. We'll call it anywhere.submit:
	Universe = vanilla
	Executable = SDE-2.py
	Arguments = 0.25 500000
	Error = log/anywhere.err.$(Cluster)-$(Process)
	Output = log/anywhere.out.$(Cluster)-$(Process)
	Log = log/anywhere.log.$(Cluster)
	Queue 100

## Getting Help
For assistance or questions, please email the OSG User Support team  at `user-support@opensciencegrid.org` or visit the [help desk and community forums](http://support.opensciencegrid.org).
