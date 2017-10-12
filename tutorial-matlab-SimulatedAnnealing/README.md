[title]: - "Optimization Tool box: Simulated Annealing"
[TOC]

## Overview


[MATLAB's Optimization Toolbox](http://www.mathworks.com/products/optimization/) tackles wide variety of solvers such as linear programming, mixed-integer linear programming, quadratic programming, nonlinear optimization. In this tutorial, we learn how to use simulated annealing to find the minimum of a function. The test function is the well known Rosenbrock function. 


![fig 1](https://raw.githubusercontent.com/OSGConnect/tutorial-matlab-SimulatedAnnealing/master/Figs/RosenBrockFunction.png)

Fig.1. Two dimensional Rosenbrock function along x-y plane.  

## Tutorial files

It is easiest to start with the `tutorial` command. In the command prompt, type

	 $ tutorial tutorial-matlab-SimulatedAnnealing # Copies input and script files to the directory tutorial-matlab-SimulatedAnnealing.
 
This will create a directory `tutorial-matlab-SimulatedAnnealing`. Inside the directory, you will see the following files

    SA_Opt.m               # matlab script - simulated annealing optimization of the function `simple_objective.m`
    simple_objective.m     # matlab script - defines the actual objective function
    SA_Opt                 # matlab compiled binary
    SA_Opt.submit          # Condor job description file
    SA_Opt.sh          # Executable file
    Log/                   # Directory to copy standard output, error and log files from condor jobs.


## MATLAB script -  Objective function

Lets take a look at the objective function that takes an argument of an array x. The size of the array is two.

    function y = simple_objective(x)
         y = (1-x(1))^2 + 100*(x(2)-x(1)^2)^2;

The objective function is defined in the matlab file `simple_objective.m`. 

## MATLAB script - Optimization
The simulated annealing script calls the objective function and optimizes via `simulannealbnd`. 

    %Simulated Annealing optimization of a given function
    function SA_Optimization(fnumber)
        filenumber = num2str(fnumber);
        outfilename = sprintf ( '%s%s%s', 'rosen-sa-opt', filenumber, '.dat' );
        fileID = fopen(outfilename,'w');

        ObjectiveFunction = @simple_objective;
        rng('shuffle');
        for n = 1:1:5
            rx = rand(1:2)*100.0;
            X0 = [2.0 2.0] + rx;   % Starting point
            [x,fval,exitFlag,output] = simulannealbnd(ObjectiveFunction,X0) %
            fprintf(fileID,'f= %12.6f  x= %9.5f   y= %9.5f x0= %9.5f  y0=%9.5f\n', fval, x, X0 );
        end
        fclose(fileID);

In the above script, the optimization is repeated for five times with random initial conditions. 

## MATLAB runtime execution
As mentioned in the [lesson on basics of MATLAB compilation] (https://support.opensciencegrid.org/support/solutions/articles/5000660751-basics-of-compiled-matlab-applications-hello-world-example), we need to compile the matlab script on a machine with license.  At present, we don't have license for matlab on OSG-Conect. On a 
machine with matlab license, invoke the compiler `mcc`. It is important to turn off all 
graphical options (-nodisplay), disable Java (-nojvm), and instruct MATLAB to run this 
program as a single-threaded application (-singleCompThread). The flag -m means `c` language translation during compilation. 

    mcc -m -R -singleCompThread -R -nodisplay -R -nojvm SA_Opt.m

would produce the files: `SA_Opt, run_SA_Opt.sh, mccExcludedFiles.log and readme.txt`.  The file `SA_Opt` 
is the compiled binary file that we would like to run on OSG Connect. 

## Job execution and submission files

Let us take a look at `SA_Opt.submit` file: 


    Universe = vanilla                          # One OSG Connect vanilla, the prefered job universe is "vanilla"

    Executable =  SA_Opt.sh    # Job execution file which is transfered to worker machine
    Arguments = $(Process)     #  process ID passed as an argument
    transfer_input_files = SA_Opt               # list of file(s) need be transfered to the remote worker machine 

    Output = Log/job.$(Process).out⋅            # standard ouput 
    Error =  Log/job.$(Process).err             # standard error
    Log =    Log/job.$(Process).log             # log information about job execution
    
    requirements = HAS_MODULES == True

    queue 10                                   # Submit 10  jobs

The above job description instructs condor to submit 10 jobs. Each job would start with different random 
intial conditions. 

The executable is a wrapper⋅ script `SA_Opt.sh`

    #!/bin/bash⋅
    source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/current/init/bash
    module load matlab/2014b
    chmod +x SA_Opt
    ./SA_Opt $1

that loads the module `matlab/2014b` and executes the MATLAB compiled binary `SA_Opt`. The only required 
argument is a numerical⋅label that would be attached with the name of the output file. 



## Job submision 

We submit the job using `condor_submit` command as follows

	$ condor_submit SA_Opt.submit //Submit the condor job description file "SA_Opt.submit"

Now you have submitted an ensemble of 10 jobs. The jobs should be finished quickly (less than an hour). You can check the status of the submitted job by using the `condor_q` command as follows

	$ condor_q username  # The status of the job is printed on the screen. Here, username is your login name.


Each job produce rosen-sa-opt$(Process).dat file, where $(Process) is the process ID that runs from 0 to 9. 

## Post process 
After all jobs finished, we want to gather the output data. The script `post-script.bash` gathers the 
output values and numerically sort them according to function values. 

    $ post-script.bash⋅


## Getting Help
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).
