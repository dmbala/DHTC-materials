#!/bin/bash
cat mcpi*.out | awk '{ sum += $2; print $2"   "NR} END { print "---------------\n Grand Average = " sum/NR }'
