#!/bin/bash

state=$1

if [ $(grep -o "Z-matrix" "$state.out") ] ; then 

for j in splots tplots ; do 
	cp /home/mewes/CALC/PLOTS/${state}_tda_${j}.in PLOTS/ ; makeplotjob.sh $state.out low >> PLOTS/${state}_tda_${j}.in 
done 

else echo "Optimization not converged."
fi 

