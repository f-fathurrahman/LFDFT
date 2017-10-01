#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo
  echo "ERROR"
  echo "Need two parameters: main file and compiler name (and or options)"
  echo "Example: ./build.sh myfile.f90 \"pgf90 -O2\""
  echo
  exit 1
fi

INC="-I../"
LIB="../libmain.a ../libsparskit.a ../libpoisson_ISF.a -lblas -llapack -lfftw3"

bas=`basename $1 .f90`

# remove the previous executable
rm -vf $bas.x

$2 $INC $1 $LIB -o $bas.x

#gfortran -Wall -O3 -ffree-form $INC $1 $LIB -o $bas.x
echo "Test executable: $bas.x"

# for
#mpifort -free $INC $1 $LIB -o $bas.x
