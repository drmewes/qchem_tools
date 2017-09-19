#!/bin/bash
# created by Jan Mewes Sep 2017 www.janmewes.de

file=$1
output=$(echo $file | sed s/out/xyz/)
natoms=0
quiet=""
otherout=$2

if [ $otherout ] && [ -n $otherout ]
 then output=$otherout
 echo "Using non default outputfile $output"
 else echo  "Using default outputfile $output"
fi 

if [ ! $quiet ]
then echo "### Q-CHEM OPTIMIZED XYZ MAKER V1.0 ###"
	 echo 
	 echo "Usage: 1st argument output file (has to be an optimization)"
	 echo "       2nd optional argument: name of desired output file. Default is outputfile.xyz"
	 echo 
 	 echo "Now doing $1..."
fi 

for i in $file
	do if [ $(cat $1 | grep -c "OPTIMIZATION CONVERGED") -eq 1 ]
		then natoms=$(grep "NAtoms," $1 -A1 | tail -n1 | awk '{print $1}')
		nlines=$((natoms+4))
		[ ! $quiet ] && echo "Found $natoms atoms..."

		if [ -e $output ] 
			then cp $output "$output"_bkup
			echo "Desired output file already exists, backing up..."
		fi

		echo "$natoms" > $output
		grep "Final energy is" $file >> $output
		grep "OPTIMIZATION CONVERGED" -A $nlines $file | tail -n $natoms | cut -c 10- >> $output

		[ ! $quiet ] && echo "### All done, sweetas!"

		else echo "Optimization not converged, exiting"
	fi
done


