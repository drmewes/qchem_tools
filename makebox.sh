#!/bin/bash
# created by Jan Mewes Sep 2017 www.janmewes.de

xmin=1000
xmax=-1000
ymin=1000
ymax=-1000
zmin=1000
zmax=-1000
extra=2
natoms=0
quiet=""
qual=$2
[ $3 ] && qual=$3
mode=$2
spacing=0.0625

if [ $mode ] && [ $mode = nobla ]
 then quiet=true
fi 

#low quality mode for non-publication stuff. Coarse 0.1 A grid
if [ $qual ] && [ $qual = low ]
 then spacing=0.1
fi


if [ ! $quiet ]
then echo "### Q-CHEM PLOTBOXMAKER V1.0 ###"
	 echo 
	 echo "Usage: 1st argument output file (has to be an optimization)"
	 echo "       2nd optional argument \"nobla\": only output %plots section"
	 echo "       3rd optional argument \"low\"  : use low quality mode for smaller files"
	 echo 
 	 echo "Now boxing $1..."
fi 

file=$(basename $1)

for i in $1 
	do if [ $(cat $1 | grep -c "OPTIMIZATION CONVERGED") -eq 1 ]
		then natoms=$(grep "NAtoms," $1 -A1 | tail -n1 | awk '{print $1}')
		[ ! $quiet ] && echo "Found $natoms atoms..."
		nlines=$((natoms+4))
		for i in $(grep "OPTIMIZATION CONVERGED" $1 -A $nlines | tail -n $natoms | awk '{print $3}')
			do if [ $(echo "$i<$xmin" | bc ) -eq 1 ]
				then xmin=$i 
				#echo "New xmin = $xmin"
			fi
			if [ $(echo "$i>$xmax" | bc) -eq 1 ]
				then xmax=$i 
				#echo "New xmax = $xmax"
			fi
		done				
		for i in $(grep "OPTIMIZATION CONVERGED" $1 -A $nlines | tail -n $natoms | awk '{print $4}')
			do if [ $(echo "$i<$ymin" | bc ) -eq 1 ]
				then ymin=$i 
				#echo "New ymin = $ymin"
			fi
			if [ $(echo "$i>$ymax" | bc) -eq 1 ]
				then ymax=$i 
				#echo "New ymax = $ymax"
			fi
		done	
		for i in $(grep "OPTIMIZATION CONVERGED" $1 -A $nlines | tail -n $natoms | awk '{print $5}')
			do if [ $(echo "$i<$zmin" | bc ) -eq 1 ]
				then zmin=$i 
				#echo "New zmin = $zmin"
			fi
			if [ $(echo "$i>$zmax" | bc) -eq 1 ]
				then zmax=$i 
				#echo "New zmax = $zmax"
			fi
		done	
if [ ! $quiet ]
	then echo 
		echo "Dimensions of your system are:"
		echo "X: $xmin to $xmax" 
		echo "Y: $ymin to $ymax" 
		echo "Z: $zmin to $zmax" 
		echo
		echo "Creating a box 1.5 A larger than the molecule in every direction..."
		[ $qual ] && [ $qual = low ] && echo "Using 1/10 A grid." || echo "Using 1/16 A grid."
fi
		boxxmin=$(echo "scale=2 ; ($xmin-$extra)/1" | bc)
		boxxmax=$(echo "scale=2 ; ($xmax+$extra)/1" | bc)
		boxymin=$(echo "scale=2 ; ($ymin-$extra)/1" | bc)
		boxymax=$(echo "scale=2 ; ($ymax+$extra)/1" | bc)
		boxzmin=$(echo "scale=2 ; ($zmin-$extra)/1" | bc)
		boxzmax=$(echo "scale=2 ; ($zmax+$extra)/1" | bc)
		xgrid=$(echo "($xmax-($xmin))/$spacing" | bc)
		ygrid=$(echo "($ymax-($ymin))/$spacing" | bc)
		zgrid=$(echo "($zmax-($zmin))/$spacing" | bc)
		[ ! $quiet ] && echo "... and writing it, for your convenience, in Q-Chem %plot format:" ; echo 
		echo "\$plots"
		echo "att. det. elec. hole and diff. dens for $file"
		echo "$xgrid $boxxmin $boxxmax"
		echo "$ygrid $boxymin $boxymax"
		echo "$zgrid $boxzmin $boxzmax"
		echo "0 0 0 2"
		echo "1 2"
		echo "\$end"
		echo 
		[ ! $quiet ] && echo "### All done, sweetas!"

		else echo "Optimization not converged, exiting"
	fi
done


