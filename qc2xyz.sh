#!/bin/bash
# created by Jan Mewes Sep 2017 www.janmewes.de

file=$1
output=$(echo $file | sed s/out/xyz/)
natoms=0
quiet=""
otherout=$2

if [ ! $quiet ]
then echo "### Q-CHEM OPTIMIZED XYZ MAKER V1.0 ###"
	 echo 
	 echo "Usage: 1st argument output file (has to be an optimization)"
	 echo "       2nd optional argument: name of desired output file. Default is outputfile.xyz"
	 echo 
 	 echo "Now doing $1..."
fi 

if [ $1 ] ; then

if [ $otherout ] && [ -n $otherout ]
 then output=$otherout
 echo "... using non default outputfile $output"
 else echo  "Using default outputfile $output"
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

else

echo "No additional input parameters provided, doing all .out files in folder... "

for i in *out ; do  
        echo "... now doing $i"
	output=$(echo $i | sed s/out/xyz/)
	if [ $(cat $1 | grep -c "OPTIMIZATION CONVERGED") -eq 1 ]
                then natoms=$(grep "NAtoms," $i -A1 | tail -n1 | awk '{print $1}')
                nlines=$((natoms+4))
                [ ! $quiet ] && echo "Found $natoms atoms..."

                if [ -e $output ]
                        then cp $output "$output"_bkup
                        echo "Desired output file already exists, backing up..."
                fi

                echo "$natoms" > $output
                grep "Final energy is" $i >> $output
                grep "OPTIMIZATION CONVERGED" -A $nlines $i | tail -n $natoms | cut -c 10- >> $output

                else echo "Optimization not converged, exiting"
        fi
done

 [ ! $quiet ] && echo "### All done, sweetas!"

fi
