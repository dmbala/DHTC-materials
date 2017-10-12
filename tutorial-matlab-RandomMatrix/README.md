[title]: - "RandomMatrix and Wigner's semi-circle law"
[TOC] 

## Overview

Wigner proved that the  distribution of eigen values from a random symmetric matrix is a semi-circle when the size of the matrix is very large.  We test the
semi-circle law with several small sized `100x100` matrices, instead of solving one huge matrix. Because, it is easy to solve several small matrices rather than one very large matrix. In general, ensemble computations are great fit for high throughput computing. In this tutorial, we  learn how to concurrently compute the eigen values of ensemble of  matrices with [MATLAB](http://www.mathworks.com/products/matlab/) utilizing the MATLAB 
runtime on OSG Connect and see the validity of the famous Wigner's semicircle law. 


![fig 1](https://raw.githubusercontent.com/OSGConnect/tutorial-matlab-RandomMatrix/master/Figs/wigner_semi_circle.png)

Fig.1. The probability density as a function of eigen values for a 100x100 random symmetric matrix. The ensemble 
averaged probability density converges to a semi-circle (red line). 

## Tutorial files

Let us utilize the `tutorial` command. In the command prompt, type

	 $ tutorial matlab-RandomMatrix # Copies input and script files to the directory tutorial-matlab-RandomMatrix.
 
This will create a directory `tutorial-matlab-RandomMatrix` with the following files

    wigner_distribution.m       # matlab script - computes eigen values of a random matrix and their histogram
    wigner_distribution         # compiled binary of wigner_distribution.m 
    wigner_distribution.submit  # condor job description file 
    wigner_distribution.sh      # Execution script 
    Log/                        # Directory to copy the standard output, error and log files from condor jobs. 
    average_prob.py             # utility python script used by post-script.bash
    post-script.bash            # script gathers output data after completing condor jobs

## MATLAB script -  Wigner's semi circle distribution

The matlab script takes two argument `n` and `fnumber`. The argument `n` defines the size of matrix. The argument `fnumber` is used to label the output file. The matlab script generates a random symmetric matrix of size `nxn`, computes the eigen values and finds the probability density of the eigen values. 

    function my_function(n, fnumber)
        %intialize variables: n is the size of matrix, dx is bin width, fnumber is used to label the output filename
        filenumber = num2str(fnumber);
        if ischar(n)
            n = str2num(n);
        end
        dx = 0.05;

        % Compute eignvalues of a nxn random matrix⋅⋅
        rng('shuffle')
        a = randn(n);
        M = (a + a')/2;  % construct the symetric random matrix⋅
        e = eig(M); % solve for the eigen values⋅
        e = e/(sqrt(2*n));

        %compute histogram
        [m x] = hist(e, -1.1:dx:1.1); % compute histogram
        m = m/(n*dx);
        values = [x;m];

        % print outputs
        outfilename = sprintf ( '%s%s%s', 'prob_wigner', filenumber, '.dat' );
        fileID = fopen(outfilename,'w');
        fprintf(fileID,'%9.3f   %9.4f\n', values);
        fclose(fileID);

In the above script,  the line `rng('shuffle')`  means the random number is non-repeated.  The script 
produces the probability density of eigen values in a file `prob_wigner$fnumber.dat` where filenumber is an input integer attached with the filename. 

## MATLAB runtime execution

As mentioned in the [lesson on basics of MATLAB compilation](https://support.opensciencegrid.org/support/solutions/articles/5000660751-basics-of-compiled-matlab-applications-hello-world-example), we need to compile the matlab script on a machine with license. At present, OSG connect does not have license for matlab.  On a machine with matlab license, invoke the compiler `mcc`. We turn off all graphical options (-nodisplay), disable Java (-nojvm), and instruct MATLAB to run this program as a single-threaded application (-singleCompThread). 

    mcc -m -R -singleCompThread -R -nodisplay -R -nojvm wigner_distribution.m

The flag -m means `c` language translation during compilation and the flag `-R` is the option for runtime. The compilation  would produce the files: wigner_distribution, run_wigner_distribution.sh, mccExcludedFiles.log and readme.txt files. 

The file `wigner_distribution` is the compiled binary file which we run on OSG Connect as HTCondor job. 

## Job execution and submission files

Let us take a look at the  condor job description file `wigner_distribution.submit`: 

    Universe = vanilla                          # The job universe is "vanilla"
    
    Executable =  wigner_distribution.sh        # The job execution file which is transferred to worker machine
    Arguments = 100 $(Process)                  # "list of arguments": (1) Size of matrix. (2) process ID. 
    transfer_input_files = wigner_distribution  # list of file(s) need be transferred to the remote worker machine 

    Output = Log/job.$(Process).out⋅            # standard output 
    Error =  Log/job.$(Process).err             # standard error
    Log =    Log/job.$(Process).log             # log information about job execution
    
    requirements =  Arch == "X86_64" && HAS_MODULES == True   # Check if the worker machine has CVMFS 

    queue 100                                   # Submit 100  jobs

The above job description instructs condor to submit 100 jobs. The executable is a wrapper 
script `wigner_distribution.sh`

    #!/bin/bash⋅
    source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/current/init/bash
    module load matlab/2014b
    chmod +x wigner_distribution
    ./wigner_distribution $1 $2⋅

that loads the module `matlab/2014b` and executes the MATLAB compiled binary `wigner_distribution`. The 
execution requires two 
arguments. The first argument is the size of the random matrix and the next argument is a numerical 
label attached with the name of the output file. 

## Job submmision 

We submit the job using `condor_submit` command as follows

	$ condor_submit wigner_distribution.submit //Submit the condor job description file "wigner_distribution.submit"

Now you have submitted an ensemble of 100 MATLAB jobs that solves the eigen values of a random matrix of size 100.  The present job should be finished quickly (less than an hour). You can check the status of the submitted job by using the `condor_q` command as follows

	$ condor_q username  # The status of the job is printed on the screen. Here, username is your login name.


Each job produces prob_wigner$(Process).dat file, where $(Process) is the process ID runs from 0 to 99. The probability distribution of eigen values computed for each random matrix is written on a output file. 


## Post process 

After all jobs finished running, we find the average probability density and compare with the density from just one matrix to see how the averaging improves the convergence of semi-circle distribution.  The 
script `post-script.bash` computes the average of  probability density, generates `gnuplot` plot of 
comparing the average with the density distribution from one matrix and finally saves the plot in a 
image  file`wigner-semi-circle.png`.  To get the plot from the output data, type 

    $ post-script.bash 

The script calls the python program `average_prob.py` to compute the average probability density from all the output files and `gnuplot` for plot.

## Getting Help
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).
