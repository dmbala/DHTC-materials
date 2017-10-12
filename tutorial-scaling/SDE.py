#!/bin/env python
# SDE.py: calculate the transition rate of a particle in a well
# COMMAND TO RUN: ./SDE-script.py $Temp $Numt
# https://github.com/patrickmalsom/SDE

from math import sqrt     # import sqrt function
from sys import argv      # command line arguments
import random  # random number library
from os import urandom    # used to seed the random number generator (RNG)
from time import clock    # time the run
start = clock()           # start timing

# Define the constants
Temp=float(argv[1])       # configurational Temperature
Numt=int(argv[2])         # total number of time steps. Numt=500000 takes ~ 1 second
dt=0.001                  # time step
xstart=1.0                # starting position
basin=xstart              # value of the last visited basin
trans=0                   # number of transitions completed
pref=sqrt(2*Temp*dt)      # prefactor for the thermal weight
trans=0                   # number of transitions completed
basin=xstart              # value of the last visited basin
xold=xstart;              # initialize the starting point

# define the force ( for this example V(x)=(x^2-1)^2 )
def F(x): return 4*x*(1-x*x)
for i in range(Numt):
    # Perform the next step. Uses a gaussian random number at each step.
    xnew=xold+dt*F(xold)+pref*random.gauss(0,1);
    # Test to see if a transition has occured
    # Assumes: abs(xnew-xold) < 1
    if abs(xnew) > 1.0 and basin * xnew < 0.0 :
        # True: incriment transition counter
        trans=trans+1;
        # change the last visited basin
        if xnew > 0.0 :
            basin=1.0;
        else:
            basin=-1.0;
    # update xold
    xold=xnew;
elapsed = (clock() - start); # stop timing

# Print the results to std out
print "Temp=%f \t Trans=%d, Elapsed time:%f" % (Temp,trans,elapsed)
