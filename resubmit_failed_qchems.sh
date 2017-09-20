#!/bin/bash

for  i in *in 
	do j=$(echo $i | sed s/in/out/ ) 
	   k=$(echo $i | sed s/in/sh/)
 	test=$(tail -n50 $j | grep -o Thank )
	if [ "$test" == "Thank" ] 
		then echo "$i CONVERGED" 
		else echo "$i NOT CONVERGED, resubmitting..."
		sbatch $k 
	fi  
done 

