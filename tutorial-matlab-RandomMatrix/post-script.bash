#!/bin/bash
python average_prob.py > ave_prob_wigner.dat    # computes the ensemble average of probability density from all the output files prob_wigner*.dat

###   Compare the averaged probability density with the probability from one of the matrix (prob_wigner0.dat) and save the plot as png file. 
echo "#!/usr/bin/gnuplot -persist " > gnuplot-script.plt 
echo "set term  png " >> gnuplot-script.plt
echo "set output 'wigner_semi_circle.png'" >> gnuplot-script.plt
echo "set xlabel 'Probability Density'" >> gnuplot-script.plt 
echo "set ylabel 'Eigen Values' " >> gnuplot-script.plt 
echo "set yrange [0.0:1.0001]" >> gnuplot-script.plt
echo "set title 'Wigner Semi-Circle Distribution' " >> gnuplot-script.plt 
echo "plot 'ave_prob_wigner.dat' u 1:2 w l lc 1 lw 5, 'prob_wigner0.dat' u 1:2 w i lc 2 lw 5" >> gnuplot-script.plt 
chmod +x gnuplot-script.plt 
./gnuplot-script.plt 
rm gnuplot-script.plt


