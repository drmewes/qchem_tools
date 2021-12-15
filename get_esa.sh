#!/bin/bash

states=1
einit=0

if test -f $1 && [[ $(grep "Have a nice day." $1) ]] && [[ $(grep "sts_mom" $1) ]] ; then 

outfile=$(echo $1)  

if [ $(grep -c "Welcome to Q-Chem" $outfile) -gt 1 ] ; then
	echo "More than one job, taking the latter one..."
	grep "User input: [2-9] of [2-9]" $outfile -A 1000000 > __temp.out
	outfile="__temp.out"
fi
	
states=$(grep cis_n_roots $outfile | awk '{print $2}') 
einit=$(grep "Excited state   1:" $outfile | awk '{print $8}') 

for i in $(seq 2 $states) ; do 
	efinal=$(grep "Excited state *  $i:" $outfile | awk '{print $8}') 
	ee=$(echo "$efinal - $einit" | bc) 

	fosc=$(grep "Transition Moments Between" -A200 $outfile | grep " 1   *$i " | awk '{print $6}') 
	echo "$ee $fosc" 
done 

test -f __temp.out && rm __temp.out

else

	echo "File $1 does not exist, calc. not converged, or no state-to-state properties calculated"

fi 

