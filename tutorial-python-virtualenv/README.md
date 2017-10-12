[title]: - "Virtualenv in Python"
[TOC]

## Overview

In this tutorial, we learn how to create and use Python virtualenv on the OSG. As an example, we create a virtual environment that holds  NLTK (Natural Language Tool Kit) library and  then run an NLTK analysis using the virtualenv. 


## Tutorial files

It is easiest to start with the `tutorial` command. In the command prompt, type

	 $ tutorial python-virtualenv # Copies input and script files to the directory python-virtualenv.
 
This will create a directory `tutorial-virtualenv`. Inside the directory, you will see the 
following files

     text_nltk_venv.sh          # Job wrapper script
     text_nltk_venv.submit      # HTCondor job description file
     simple_text_analysis.py    # Python program to analyze the text 
     nltk_data.tar.gz           # NLTK reference data 
     nltk_env.tar.gz            # Virtual environment for NLTK inside python2.7
     create_virtenv.sh          # Script to create the virtual environment


Here, `text_nltk_venv.submit` is the job submission file, `text_nltk_venv.sh.sh` is the wrapper shell script, `simple_text_analysis.py` is the Python program that does the text analysis using NLTK library, `nltk_data.tar.gz` is the reference 
data for NLTK analysis, and `nltk_env.tar.gz` is the virtual environment that contains Python2.7 and NLTK packages. The shell script `create_virtenv.sh` creates the virtual environment for NLTK package with Python 2.7. 

## Installation of a Python package via virtual environment

The shell script `create_virtenv.sh` completes the following tasks: 

    1. Creates a virtual environment called `nltk_env`
    2. Activates the virtual environment 
    3. Installs the package `NLTK` into the virtual environment 
    4. Produces a compressed file of the virtual environment


Let us go through the above steps as outlined in `create_virtenv.sh`.  We create the virtual environment with Python version 2.7 which is available on the submit node (login.osgconnect.net) as distributed environmental modules [REF]. 

The module command is used to load Python2.7 


     $ module load python/2.7

and create an isolated virtual environment called `nltk_env` using the tool `virutalenv-2.7` (Feel free to choose a different name instead of `nltk_env`).

     $ virtualenv-2.7 nltk_env
     New Python executable in nltk_env/bin/python
     Installing setuptools, pip...done.

This creates a directory `nltk_env` in the current working directory with sub-directories bin/, include/, and lib/.   

Take a look at the list of site-packages 

    $ ls nltk_env/lib/python2.7/site-packages/ 
    easy_install.py   _markerlib  pip-6.0.8.dist-info  setuptools
    easy_install.pyc  pip	  pkg_resources	   setuptools-12.0.5.dist-info 

In the above listing, there is no `nltk` package. So we need to install the package `NLTK` in the virtual environment. We first activate the virtual environment 

    $ source nltk_env/bin/activate
    (nltk_env)$

The activation process redefines some of the shell variables such as PYTHON_PATH, LIBRARY_PATH etc. Furthermore, it changes the shell prompt by adding
the name of the virtual environment (nltk_env in the present example) as prefix. 

After activation, we are ready to add the packages with `pip` which is a tool to install Python packages. 

    (nltk_env)$ pip install nltk
    ......some download message...
    Installing collected packages: nltk
    Running setup.py install for nltk
    Successfully installed nltk-3.2.1 

Let us check weather the installed package exist under site-packages directory

    (nltk_env)$ ls nltk_env/lib/python2.7/site-packages/ | grep nltk
    nltk
    nltk-3.2.1-py2.7.egg-info

We finished the installation of NLTK package. Now it is okay to come out of the virtual environment, type 
    (nltk_env)$ deactivate

The above command resets the shell environmental variables and returns you to the normal shell prompt (the prefix `nltk_env` disappears)

    $ 


Now the virtual environment is ready. Next step is to make this virtual environment available on the remote worker machine when the job is being executed. So it is good to compress the whole directory `nltk_env`  and send it along with the HTCondor job. 

   $ tar xzf nltk_env.tar.gz nltk_env

# Job submission and execution files

Let us take a look at the job description file

    #The UNIVERSE defines an execution environment. You will almost always use VANILLA. 
    Universe = vanilla     
    # EXECUTABLE is the program your job will run It's often useful 
    # to create a shell script to "wrap" your actual work. 
    Executable = text_nltk_venv.sh

    transfer_input_files = nltk_data.tar.gz, nltk_env.tar.gz, simple_text_analysis.py 

    # The LOG file is where HTCondor places information about your 
    # job's status, success, and resource consumption. 
    log           = job.log

    # The standard output and error messages
    output        = job.out
    error         = job.error

    # Set the requirement that the OASIS modules are available on the remote worker machine
    requirements = (HAS_CVMFS_oasis_opensciencegrid_org =?= TRUE)

    # QUEUE is the "start button" - it launches any jobs that have been 
    # specified thus far. 
    Queue 1

Note that we transfer the compressed virtual environment file `nltk_env.tar.gz`. On the remote worker machine, the virtual environment is uncompressed and activated before actual the Python program is executed via the wrapper  script `text_nltk_venv.sh`. 


    #!/bin/bash

    # Extract the "nltk_env" and "nltk_data"
    tar -xzf nltk_env.tar.gz
    tar -xzf nltk_data.tar.gz 

    # Load Python 2.7 (should be the same version used to create the virtual environment)
    module load python/2.7

    # Create the virtual environment on the remote hosts (redefines the env variables)
    virtualenv-2.7 nltk_env

    # Activate virtual environment
    source nltk_env/bin/activate

    # Run the Python script 
    python simple_text_analysis.py > simple_text_analysis.out

    # Deactivate virtual environment 
    deactivate

    # Clean up the data on the remote machine 
    rm nltk_env.tar.gz nltk_data.tar.gz
    rm -rf nltk_env nltk_data

## Running the simulation

We submit the job using `condor_submit` command as follows

	$ condor_submit  text_nltk_venv.submit //Submit the condor job script "text_nltk_venv.submit"

Now you have submitted a job that performs NLTK analysis of English text. The present job should be finished quickly (less than an hour). You can check the status of the submitted job by using the `condor_q` command as follows
    
	$ condor_q username  # The status of the job is printed on the screen. Here, username is your login name.

After the job completion, you will see the output file `simple_text_analysis.out`. 


## Getting Help
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).
