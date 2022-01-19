#!/bin/bash

state=$1

if [ $(grep -o "Z-matrix" "$state.out") ] ; then 

for j in splots tplots ; do 
	cp /home/mewes/CALC/PLOTS/${state}_${j}.in PLOTS/ ; makeplotjob.sh $state.out low >> PLOTS/${state}_${j}.in 
done 

else echo "Optimization not converged."
fi 

