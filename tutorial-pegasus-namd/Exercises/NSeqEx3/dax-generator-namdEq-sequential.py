#!/usr/bin/env python

from Pegasus.DAX3 import *
import sys
import os

base_dir = os.getcwd()

# Create a abstract dag
dax = ADAG("namd-N-Sequential")

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
param_dir = base_dir + "/paramdirs"
for paramfile_name in os.listdir(param_dir):
    param_file = File(paramfile_name)
    param_file.addPFN(PFN("file://" + param_dir + "/" + paramfile_name, "local"))
    dax.addFile(param_file)

# add jobs, one for each input file
job_count = 0
for i in range (0,0): 
    in_name = "ubq_gbis_eq_dag-S" + "1" + ".Jo" + `i` + ".conf"
    #print in_name
    # Add input file to the DAX-level replica catalog
    in_file = File(in_name)
    in_file.addPFN(PFN("file://" + inputs_dir + "/" + in_name, "local"))
    dax.addFile(in_file)

    # Add job
    namdEq_job = Job(name="namd_exe.bash")
    out_file = File(in_name + ".out.tar.gz")
    dax.addJob(namdEq_job)

    if i == 0:
       namdEq_job.addArguments(in_file, out_file)
    else:
       i1 = i -1 
       namdEq_job.uses(restart_file, link=Link.INPUT)
       namdEq_job.addArguments(in_file, out_file, restart_file)

    namdEq_job.uses(in_file, link=Link.INPUT)
    namdEq_job.uses(out_file, link=Link.OUTPUT)


    for paramfile_name in os.listdir(param_dir):
         param_file = File(paramfile_name)
         param_file.addPFN(PFN("file://" + param_dir + "/" + paramfile_name, "local"))
         namdEq_job.uses(param_file, link=Link.INPUT)



    restart_file = out_file
    #Add job dependencies
    if job_count > 0:
       dax.addDependency(Dependency(parent=namdEq_jobOld, child=namdEq_job))
    namdEq_jobOld = namdEq_job
    job_count += 1


# Write the DAX to stdout
f = open("dax.xml", "w")
dax.writeXML(f)
f.close()



