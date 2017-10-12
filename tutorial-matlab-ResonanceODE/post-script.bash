#!/bin/bash
cat XmaxFreq*.dat | sort -n -k 4 > all_XmaxFreq.dat  # combine the response from applied frequencies

### plot the response Vs frequency plot
echo "#!/usr/bin/gnuplot -persist " > gnuplot-script.plt
echo "set term  png " >> gnuplot-script.plt
echo "set output 'all_XmaxFreq.png'" >> gnuplot-script.plt
echo "set xlabel 'Applied Frequency/Natural Frequency'" >> gnuplot-script.plt
echo "set ylabel 'Amplitude' " >> gnuplot-script.plt
echo "set title 'Response of a damped, driven harmonic oscillator' " >> gnuplot-script.plt 
echo "plot 'all_XmaxFreq.dat' u 4:2 w lp lc 1 lw 5" >> gnuplot-script.plt 
chmod +x gnuplot-script.plt
./gnuplot-script.plt
rm gnuplot-script.plt

