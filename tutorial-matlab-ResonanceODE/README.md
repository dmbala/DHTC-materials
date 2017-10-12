

[title]: - "Parameter sweep: Resonance in a driven-damped harmonic oscillator" 
[TOC]

## Overview


Parameter sweeps are efficiently handled in an high throughput computing environment. To keep things simple, we sweep a single parameter in a simple model. The model is driven-damped harmonic  oscillator and is based on ordinary differential equation (ODE). The ODE is solved using [MATLAB](http://www.mathworks.com/products/matlab/). For the  driven-damped harmonic oscillator, the resonance is set when the applied frequency is equal to the natural frequency. Under the resonance condition, the oscillator vibrates with large amplitude. We sweep the applied frequency and find out when the oscillator has a maximum amplitude. 

![fig 1](https://raw.githubusercontent.com/OSGConnect/tutorial-matlab-ResonanceODE/master/Figs/response.png)

Fig.1. The amplitude of driven-damped oscillator as a function of driving frequency. The amplitude is normalized with respect to the initial 
displacement and the driving frequency is normalized with respect to the natural frequency of the oscillator. 


## Tutorial files

It is easiest to start with the `tutorial` command. In the command prompt, type

	 $ tutorial matlab-ResonanceODE # Copies input and script files to the directory tutorial-matlab-ResonanceODE.
 
This will create a directory `tutorial-matlab-ResonanceODE`. Inside the directory, you will see the following files

    driv_damp_osc.m             # matlab script - solves second order ODE for driven-damped harmonic oscillator
    driv_damp_osc               # compiled executable binary of driv_damp_osc.m
    driv_damp_osc.submit        # condor job description file
    driv_damp_osc.sh            # condor execution script
    Log/                        # Directory to copy the standard output, error and log files from condor jobs. 
    post-script.bash            # script used to gather the output data after completing condor jobs


## MATLAB script -  Damped, Driven Harmonic Oscillator 

The matlab script takes one argument `fnumber`. The argument `fnumber` is used to label the output file. The matlab script solves the ODE 
using the in-built ODE45 solver. The ODE45 solves non-stiff ODE's based on Runge-Kutta formula. 

    %  Damped, driven harmonic oscillator: nonstiff ODE

    function dd_oscillator(fnumber)

        % Set up the initial condition
        omega = 1;      % natural frequency = sqrt(k/m)
        b = 0.3;        % drag coefficient s
        m = 1.0;        % mass⋅
        x0 = 1.0;       % initial position
        v0 = 1.0;       % initial velocity
        F0 = 1.0;       % strength of applied frequency⋅
        tBegin = 0;     % time begin
        tEnd = 80;      % time end

        % Applied frequency is chosen from random generator⋅
        rng('shuffle');
        omega_app = rand(1)*2.5;   % driving frequency


        % Use Runge-Kutta integrator to solve the ODE
        [t,w] = ode45(@derivatives, [tBegin tEnd], [x0 v0]);
        x = w(:,1);     % extract positions from first column of w matrix
        v = w(:,2);     % extract velocities from second column of w matrix

        xmax_norm = max(x)/x0   %normalize the displacement⋅
        omega_app_norm = omega_app/omega  %normalize the applied frequency


        % Write the outputs on a file⋅
        filenumber = num2str(fnumber);
        outfilename = sprintf ( '%s%s%s', 'XmaxFreq', filenumber, '.dat' );
        fileID = fopen(outfilename,'w');
        fprintf(fileID,'xmax_norm= %9.3f  omega_app_norm= %9.3f\n', xmax_norm, omega_app_norm);
        fclose(fileID);

        % Function to compute the  derivatives of dx/dt and dv/dt
        % The parameters m, b, F0, omega_app are from the main program⋅
        function derivs = derivatives(tf,wf)
            xf = wf(1);            % wf(1) stores x
            vf = wf(2);            % wf(2) stores v
            dxdt = vf;                                     % set dx/dt = velocity
            dvdt = - m*xf - b * vf + F0*cos(omega_app*tf);  % set dv/dt = acceleration
            derivs = [dxdt; dvdt];  % return the derivatives
        end

    end

In this MATLAB script,  the applied frequency `omega_app` is a random number that falls between 0 
and 2.5. Whenever `omega_app = omega`, the resonance is set.  

## MATLAB runtime execution

As mentioned in the [lesson on basics of MATLAB compilation](https://support.opensciencegrid.org/support/solutions/articles/5000660751-basics-of-compiled-matlab-applications-hello-world-example), we need to compile the matlab script on a machine with license. At present, we don't have license for matlab on OSG conect.  On a machine with matlab license, invoke the compiler `mcc`. We turn off all graphical options (-nodisplay), disable Java (-nojvm), and instruct MATLAB to run this program as a single-threaded application (-singleCompThread). The flag -m means `c` language translation during compilation. 

    mcc -m -R -singleCompThread -R -nodisplay -R -nojvm driv_damp_osc.m

would produce the files: `driv_damp_osc, run_driv_damp_osc.sh, mccExcludedFiles.log and readme.txt`.  The file `driv_damp_osc` is the compiled binary file that we run on OSG Connect.

## Job execution and submission files

Let us take a look at `driv_damp_osc.submit` file: 


    Universe = vanilla                          # the job universe is "vanilla"

    Executable =  driv_damp_osc.sh    # Job execution file which is transferred to worker machine
    Arguments = $(Process)   # list of arguments: process ID used to label the output filename.
    transfer_input_files = wigner_distribution  # list of file(s) need be transferred to the remote worker machine 

    Output = Log/job.$(Process).out⋅            # standard output 
    Error =  Log/job.$(Process).err             # standard error
    Log =    Log/job.$(Process).log             # log information about job execution
    
    requirements =  Arch == "X86_64" && HAS_MODULES == True  # Check if the worker machine has CVMFS 

    queue 100                                   # Submit 100  jobs

The above job description instructs condor to submit 100 jobs. Each job would find the response of the 
oscillator with a random applied frequency. The executable is a wrapper⋅ script `driv_damp_osc`

    #!/bin/bash
    source /cvmfs/oasis.opensciencegrid.org/osg/modules/lmod/current/init/bash
    module load matlab/2014b
    chmod +x driv_damp_osc
    ./driv_damp_osc $1

that loads the module `matlab/2014b` and executes the MATLAB compiled binary `driv_damp_osc`. The only 
required argument is a numerical⋅ label attached with the name of the output file.⋅


## Job submission 

We submit the job using `condor_submit` command as follows

	$ condor_submit driv_damp_osc.submit  # Submit the condor job 

Now you have submitted 100 MATLAB jobs that solves ODE for randomly generated applied frequency. The present job should be finished quickly (less than two hours). You can check the status of the submitted job by using the `condor_q` command as follows

	$ condor_q username  # The status of the job is printed on the screen. Here, username is your login name.

Each job produce XmaxFreq$(Process).dat file, where $(Process) is the process ID runs from 0 to 99. Each output file contains the amplitude 
and the applied frequency. 

## Post process 

After all jobs finished, we want to gather the output data. The script `post-script.bash` gathers the 
output values in a file `all_XmaxFreq.dat` and generates the figure `all_XmaxFreq.png`.  The plotting package `gnuplot` is used to produce the figure. To get the 
plot from the output data, type 

    $ post-script.bash 

## Getting Help
For assistance or questions, please email the OSG User Support team  at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) or visit the [help desk and community forums](http://support.opensciencegrid.org).
