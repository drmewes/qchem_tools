#!/bin/bash

if [ $(grep -o "Z-matrix" gsopt.out) ] ; then 
echo "Vacuum optimization converged, copying templated and starting optimizations with PCM."

qc2mol.sh gsopt.out

cp -r /data/mewes/CALC/TADF/GSOPT+PCM/ .

cp gsopt.mol GSOPT+PCM

cd GSOPT+PCM

if [ "$1" == "sub" ] ; then 
  echo "Found flag to submit jobs..."
  for i in *in ; do 
    subqchem_old -p4 -m2 $i 
  done
fi

cd -

else echo "Vacuum gsopt not converged."
fi
