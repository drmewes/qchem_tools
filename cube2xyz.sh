#!/bin/bash

#Extract coordinate information from a cube file (1st argument) and write to 
#xyz file (2nd argument). 

natoms=0
file=$1
outfile=$2

natoms=$(head -n 3 $file | tail -n 1 | awk '{print $1}')
echo -n "Found $natoms atoms..."
nlines=$((natoms+6))

if [ $outfile ] ; then
echo -n " writing to file $outfile..."
echo $natoms > $outfile
echo "xyz from $file" >> $outfile

#echo -n " doing atom: "
for i in $(seq 7 $nlines) ; do #go through each line and turn atomic numbers into elements and convert bohr to angstroem
	line=$(head -n $i $file | tail -n 1) 
	atom=$(echo $line | awk '{print "_"$1"_"}' | sed s/_1_/H/ | sed s/_2_/He/ | sed s/_3_/Li/ | sed s/_4_/Be/ | sed s/_5_/B/ | sed s/_6_/C/ | sed s/_7_/N/ | sed s/_8_/O/ | sed s/_9_/F/ | sed s/_10_/Ne/ | sed s/_16_/S/)
	x=$(echo $line | awk '{printf "% 3.8f", $3/1.889725989}')
	y=$(echo $line | awk '{printf "% 3.8f", $4/1.889725989}')
	z=$(echo $line | awk '{printf "% 3.8f", $5/1.889725989}')
	echo -e "$atom \t $x \t $y \t $z" >> $outfile
	#echo -n "$((i-6)), "
done

else 

echo " no output-file given, writing to stdout:"
echo "############## XYZ file below this line #################"
echo $natoms 
echo "XYZ coordinates from $file"

#echo -n " doing atom: "
for i in $(seq 7 $nlines) ; do #go through each line and turn atomic numbers into elements and convert bohr to angstroem
	line=$(head -n $i $file | tail -n 1) 
	atom=$(echo $line | awk '{print "_"$1"_"}' | sed s/_1_/H/ | sed s/_2_/He/ | sed s/_3_/Li/ | sed s/_4_/Be/ | sed s/_5_/B/ | sed s/_6_/C/ | sed s/_7_/N/ | sed s/_8_/O/ | sed s/_9_/F/ | sed s/_10_/Ne/ | sed s/_16_/S/)
	x=$(echo $line | awk '{printf "% 3.8f", $3/1.889725989}')
	y=$(echo $line | awk '{printf "% 3.8f", $4/1.889725989}')
	z=$(echo $line | awk '{printf "% 3.8f", $5/1.889725989}')
	echo -e "$atom \t $x \t $y \t $z"
	#echo -n "$((i-6)), "
done

echo " ########################################################"
fi

echo " all done!"
