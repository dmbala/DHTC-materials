[title]: - "Transferring data with HTCondor"

## Overview

This page will introduce you to transferring files using HTCondor's built-in transfer mechanisms.  HTCondor has a built-in mechanism to transfer binaries and files to and from compute nodes.  If you have relatively small amounts of data and binaries to transfer (<1 Gigabyte/job) then this mechanism can be effective.

## Preliminaries

Login to `login.osgconnect.org` and get a copy of the tutorial files:

	$ ssh login.osgconnect.org
	$ tutorial htcondor_transfer
	$ cd tutorial-htcondor_transfer

## Word Distribution Example

This example will use the HTCondor transfer mechanisms to transfer a binary (distribution) and a file with a list of words (random_words) to compute nodes that are running the jobs. Create the condor file `transfer.submit`:

	universe = vanilla
	notification=never
	executable = app_script.sh
	output = logs/transfer.out.$(Process)
	error = logs/transfer.err.$(Process)
	log = logs/transfer.log
	 
	transfer_input_files = distribution, random_words
	ShouldTransferFiles = YES
	when_to_transfer_output = ON_EXIT
	 
	queue 50

The key parts of the submit file are under the `transfer_input_files` parameter that gives a comma separated list of paths to the files that will be transferred.  In addition, `ShouldTransferFiles` needs to be set to `YES` and `when_to_transfer_output` needs to be set to `ON_EXIT` in order to make sure that the HTCondor will return the output.

**path warning:** You must run `condor_submit` in the same directory that you created the files and directories in. Otherwise HTCondor will give you an error due to not being able to find the distribution and random_words files

Now submit the job: 

	$ condor_submit transfer.submit

When the jobs are completed, verify the output:

	$ cat logs/transfer.out.0
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
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).
