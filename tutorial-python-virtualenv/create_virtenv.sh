#!/bin/bash

# Load python 2.7
module load python/2.7

# Create an isolated virtual environment under the directory "nltk_env". 
virtualenv-2.7 nltk_env 
# Activate "nltk_env" that sets up the required env variables 
source nltk_env/bin/activate
# Install "nltk" package with "pip" 
pip install nltk
# Deactivate "nltk_env" that unsets the virtual env variables 
deactivate
# make a compressed tar ball 
tar -cvzf nltk_env.tar.gz nltk_env
