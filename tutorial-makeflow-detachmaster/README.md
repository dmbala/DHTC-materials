[title]: - "Makeflow - Detach master from the terminal"
[TOC]
 
## Overview

It is okay to run Makeflow on the terminal when jobs complete in few minutes.  What if you want to run many jobs 
that may run for several days and weeks. If you log out from the submit node, the master process will be killed. 
Since the master process keeps track of the workers that are distributed on OSG machines, you need to re-submit 
Makeflow. 

It is a good idea to run Makeflow in the detached mode. There are several ways to detach the master process from the 
terminal, such as `SCREEN`, `tmux`, and `condor job as `local universe`.

In this tutorial, we learn how to keep the master process alive with condor local job even after closing the terminal. 

## tutorial files

For this tutorial, we use the workflow of generating Fibonacci sequence that was used in the previous tutorial 
"makeflow-quickstart"[ref]. In the command prompt, type

    $ tutorial makeflow-detachmaster # Copies input and script files to the directory tutorial-makeflow-detachmaster

This will create a directory `tutorial-makeflow-detachmaster`. Inside the directory, you will see the following files

    fibonacci.bash                 # A simple bash script that generates the Fibonacci sequence
    fibonacci.makeflow             # The Makeflow file
    local_condor_makeflow.submit   # HTcondor file to detach the master process from the terminal

The file `fibonacci.bash` is the job script, the file `fibonacci.makeflow` describes the make rules, and the
file `local_condor_makeflow.submit` is the HTCondor description that runs the master process as local condor job.

We focus on how to run the master process as a local condor jobs. Check the "makeflow-quickstart"[ref] for the details of Makeflow. 

## Run master process as a local condor job. 

Let us take a look at the file `local_condor_makeflow.submit`

    $ cat local_condor_makeflow.submit 
    universe = local
    getenv = true
    executable = /usr/bin/makeflow
    arguments = -T condor fibonacci.makeflow
    log = local_condor.log
    queue


This is the HTcondor job description file.  The first line says that the job universe is local and the job would
run on the submit node. The executable for the job is `/usr/bin/makeflow` with an argument `-T condor fibonacci.makeflow`. The keyword `queue` is the start button 
that submits the above three lines to the HTCondor batch system. 

Submit the local condor job, 

    $ condor_submit local_condor_makeflow.submit 
    Submitting job(s).
    1 job(s) submitted to cluster 367027.

Check the job status

    $ condor_q username -w

    -- Submitter: login01.osgconnect.net : <192.170.227.195:21720> : login01.osgconnect.net
     ID      OWNER            SUBMITTED     RUN_TIME ST PRI SIZE CMD               
    19150583.0   dbala           4/1  11:54   0+00:01:54 R  0   0.4  makeflow -T condor fibonacci.makeflow
    19150584.0   dbala           4/1  11:54   0+00:00:40 I  0   0.0  condor.sh fibonacci.bash 20 > fib.20.out
    19150585.0   dbala           4/1  11:54   0+00:00:20 I  0   0.0  condor.sh fibonacci.bash 10 > fib.10.out

The above output shows that the master is running and the two workers are waiting in the queue. The Makeflow execution is a 
local condor job so it starts quickly. The two workers that run Rules 1 and 2 are distributed on OSG machines and they are waiting for resources. The jobs would complete in few minutes. 

## Summary

    There are several ways to detach the master process from the terminal, such as nohup, SCREEN, tmux, and condor local job. 
    We recommend running the master as a local condor job on the submit node. 

## Getting Help
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).
