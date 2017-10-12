#!/usr/bin/env python

from Pegasus.DAX3 import *
import sys
import os

# Create a abstract dag
dax = ADAG("vina-ligand-receptor")

base_dir = os.getcwd()

# Add executables to the DAX-level replica catalog
vina_ex = Executable(name="vina_wrapper.bash", arch="x86_64", installed=False)
vina_ex.addPFN(PFN("file://" + base_dir + "/vina_wrapper.bash", "local"))
vina_ex.addProfile(Profile(Namespace.PEGASUS, "clusters.size", 10))
dax.addExecutable(vina_ex)

# Add config file to the DAX-level replica catalog
config_filename = "receptor_config.txt"
config_file = File(config_filename)
config_file.addPFN(PFN("file://" + base_dir + "/" + config_filename, "local"))
dax.addFile(config_file)

# Add receptor file to the DAX-level replica catalog
receptor_filename = "receptor.pdbqt"
receptor_file = File(receptor_filename)
receptor_file.addPFN(PFN("file://" + base_dir + "/" + receptor_filename, "local"))
dax.addFile(receptor_file)


input_ligands_dir = base_dir + "/input_ligands"


# add jobs, one for each ligand file
for ligand_filename in os.listdir(input_ligands_dir):
     ligand_file = File(ligand_filename)
     ligand_file.addPFN(PFN("file://" + input_ligands_dir + "/"+ligand_filename, "local"))
     dax.addFile(ligand_file)

     out_filename = ligand_filename + "-out.pdbqt" 
     log_filename = ligand_filename + "-log.txt" 
     out_file = File(out_filename)
     log_file = File(log_filename)

     vina_job = Job(name="vina_wrapper.bash")
     vina_job.addArguments(config_file, ligand_file, out_file, log_file)
     vina_job.uses(config_file, link=Link.INPUT)
     vina_job.uses(ligand_file, link=Link.INPUT)
     vina_job.uses(receptor_file, link=Link.INPUT)
     vina_job.uses(out_file, link=Link.OUTPUT)
     vina_job.uses(log_file, link=Link.OUTPUT)

     dax.addJob(vina_job)

# Write the DAX to stdout
f = open("dax.xml", "w")
dax.writeXML(f)
f.close()



