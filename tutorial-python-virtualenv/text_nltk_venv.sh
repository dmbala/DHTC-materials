#!/bin/bash

# Extract the "nltk_env" and "nltk_data"
tar -xzf nltk_env.tar.gz
tar -xzf nltk_data.tar.gz 

# Load python 2.7 (should be the same version used to create the virtual environment)
module load python/2.7

# Create the virtual environment on the remote hosts (redefines the env variables)
virtualenv-2.7 nltk_env

# Activate virtual environment
source nltk_env/bin/activate

# Run the python script 
python simple_text_analysis.py > simple_text_analysis.out

# Deactivate virtual environment 
deactivate

# Clean up the data on the remote machine 
rm nltk_env.tar.gz nltk_data.tar.gz
rm -rf nltk_env nltk_data
