#!/usr/bin/env python

from Pegasus.DAX3 import *
import sys
import os

base_dir = os.getcwd()

# Create a abstract dag
dax = ADAG("wordfreq-workflow")

# Add executables to the DAX-level replica catalog
wordfreq = Executable(name="wordfreq", arch="x86_64", installed=False)
wordfreq.addPFN(PFN("file://" + base_dir + "/wordfreq", "local"))
wordfreq.addProfile(Profile(Namespace.PEGASUS, "clusters.size", 1))
dax.addExecutable(wordfreq)

# add jobs, one for each input file
inputs_dir = base_dir + "/inputs"
for in_name in os.listdir(inputs_dir):

    # Add input file to the DAX-level replica catalog
    in_file = File(in_name)
    in_file.addPFN(PFN("file://" + inputs_dir + "/" + in_name, "local"))
    dax.addFile(in_file)

    # Add job
    wordfreq_job = Job(name="wordfreq")
    out_file = File(in_name + ".out")
    wordfreq_job.addArguments(in_file, out_file)
    wordfreq_job.uses(in_file, link=Link.INPUT)
    wordfreq_job.uses(out_file, link=Link.OUTPUT)
    dax.addJob(wordfreq_job)

# Write the DAX to stdout
f = open("dax.xml", "w")
dax.writeXML(f)
f.close()

