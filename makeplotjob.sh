#!/bin/bash
# created by Jan Mewes Sep 2017 www.janmewes.de

qual=$2
file=$1
natoms=0
nlines=0

if [ $(cat $file | grep -c "OPTIMIZATION CONVERGED") -eq 1 ]
	then natoms=$(grep "NAtoms," $file -A1 | tail -n1 | awk '{print $1}')
	nlines=$((natoms+4))

	makebox.sh $file nobla "$qual"
	echo
	echo "\$molecule"
	echo "0 1"
	grep "OPTIMIZATION CONVERGED" -A $nlines $file | tail -n $natoms | cut -c 10- 
	echo "\$end"

	else echo "Optimization not converged, exiting"
fi


