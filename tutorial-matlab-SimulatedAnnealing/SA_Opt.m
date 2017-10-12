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

