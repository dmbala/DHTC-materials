#!/bin/bash
module load libgfortran
module load fftw
module load atlas
module load lapack
module load hdf5
module load qhull
module load pcre
module load SparseSuite
module load glpk
module load octave

  octave $1
