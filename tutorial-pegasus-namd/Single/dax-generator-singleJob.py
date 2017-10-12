#!/usr/bin/env python

from Pegasus.DAX3 import *
import sys
import os

# Create an abstract dag
dax = ADAG("namd-singleJob")

#Define the path of the base, executables, inputs and param directories
base_dir = os.getcwd()
exe_dir = base_dir + "/ExeFiles"
inputs_dir = base_dir + "/inputs"
param_dir = base_dir + "/paramdirs"


# Add executables to the DAX-level replica catalog
namdEq = Executable(name="namd_exe.bash", arch="x86_64", installed=False)
namdEq.addPFN(PFN("file://" + exe_dir + "/namd_exe.bash", "local"))
namdEq.addProfile(Profile(Namespace.PEGASUS, "clusters.size", 1))
dax.addExecutable(namdEq)


# Add param file to the DAX-level replica catalog
for paramfile_name in os.listdir(param_dir):
    param_file = File(paramfile_name)
    param_file.addPFN(PFN("file://" + param_dir + "/" + paramfile_name, "local"))
    dax.addFile(param_file)


# Add input file to the DAX-level replica catalog
in_name = "ubq_gbis_eq.conf"
in_file = File(in_name)
in_file.addPFN(PFN("file://" + inputs_dir + "/" + in_name, "local"))
dax.addFile(in_file)

# Add job
namdEq_job = Job(name="namd_exe.bash")
dax.addJob(namdEq_job)
#Name of the output file
out_file = File(in_name + ".out.tar.gz")
#job arguments
namdEq_job.addArguments(in_file, out_file)

#Define what files are input and output for the program
namdEq_job.uses(in_file, link=Link.INPUT)
namdEq_job.uses(out_file, link=Link.OUTPUT)

#The files in param_dir are required input files, but they are not passed as arguments
for paramfile_name in os.listdir(param_dir):
     param_file = File(paramfile_name)
     param_file.addPFN(PFN("file://" + param_dir + "/" + paramfile_name, "local"))
     namdEq_job.uses(param_file, link=Link.INPUT)

# Write the DAX to stdout
f = open("dax.xml", "w")
dax.writeXML(f)
f.close()



