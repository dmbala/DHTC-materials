[title]: - "Access Stash remotely using HTTP"

## Overview

This tutorial will introduce you to accessing data stored on Stash remotely using HTTP, and show how to incorporate this access into your job workflow.

## Preliminaries

Login and get a copy of the tutorial files:

	$ ssh login01.osgconnect.net
	$ tutorial stash_http
	$ cd tutorial-stash_http

## Make data remotely accessible 
All user accounts on the OSG Connect login server have a directory that can be made web-accessible.  This directory is located at `~/data/public`.  To make a file or directory accessible, copy it to this directory, or a subdirectory of this directory, and give files permissions of `644` and directories permissions of `755`. E.g.:

	$ cd ~/tutorial-stash_http
	$ cp random_words ~/data/public
	$ chmod 644 ~/data/public/random_words
	$ cp -a test_directory ~/data/public/test_directory
	$ chmod 755 ~/data/public/test_directory
	$ chmod 644 ~/data/public/test_directory/test_file

## Manually Access Stash Using the Web

All the contents of the public directory are made available over HTTP.  Point your browser to  `http://stash.osgconnect.net/~username` to view the files and directory that you just made available in the previous section. You can also use `wget` to retrieve the files, e.g:

	$ cd ~/tutorial-stash_http
	$ mkdir tmp
	$ cd tmp
	$ wget --no-check-certificate http://stash.osgconnect.net/~username/test_directory/test_file

## Accessing data from Stash over HTTP from a job 

> Here is an example of using HTTP to access data from Stash from a job running on the OSG. 

The primary component of this example is the shell script that is run on the compute node.  It downloads a data file `random_words` and then generates a histogram with the most common words found in the file.  Before running this example, `app_script.sh` needs to be edited to replace `username` with the user's OSG Connect username. Edit the file `app_script.sh`:

	#!/bin/bash
	wget --no-check-certificate http://stash.osgconnect.net/~username/random_words
	chmod 700 ./distribution
	cat random_words | ./distribution

Next edit the `application/application.submit` file and replace `PROJECT_NAME` with the appropriate project name. Edit `application.submit`:

	universe = vanilla
	notification=never
	executable = app_script.sh
	output = logs/words.out.$(Process)
	error = logs/words.err.$(Process)
	log = logs/words.log
	transfer_input_files = distribution
	ShouldTransferFiles = YES
	when_to_transfer_output = ON_EXIT
	queue 50

Once that change has been made, submit the file:

	$ cd ~/tutorial-stash_http/application
	$ condor_submit application.submit

Once the jobs are completed, look at the output in the logs directory and verify that the job ran correctly:

	$ cd ~/tutorial-stash_http/application
	$ cat logs/words.out.1
	Ashkenazim |45 (0.44%) +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	BIOS       |45 (0.44%) +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Anaheim    |44 (0.43%) +++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Aymara     |44 (0.43%) +++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Arthurian  |43 (0.42%) ++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Anaxagoras |43 (0.42%) ++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Bactria    |43 (0.42%) ++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Alexis     |43 (0.42%) ++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Ariel      |43 (0.42%) ++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Aubrey     |42 (0.41%) +++++++++++++++++++++++++++++++++++++++++++++++++++++
	Baryshnikov|42 (0.41%) +++++++++++++++++++++++++++++++++++++++++++++++++++++
	Bahia      |42 (0.41%) +++++++++++++++++++++++++++++++++++++++++++++++++++++
	Angstrom   |42 (0.41%) +++++++++++++++++++++++++++++++++++++++++++++++++++++
	Asoka      |42 (0.41%) +++++++++++++++++++++++++++++++++++++++++++++++++++++
	Alcatraz   |41 (0.40%) ++++++++++++++++++++++++++++++++++++++++++++++++++++

## Getting Help
For assistance or questions, please email the OSG User Support team  at `user-support@opensciencegrid.org` or visit the [help desk and community forums](http://support.opensciencegrid.org).
