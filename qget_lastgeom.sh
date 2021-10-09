#!/bin/bash

echo "Q-Chem structure extrakt0r. Usage: qget_lastgeom.sh qchem.out structure.mol charge multiplicity"

#Take the last structure from a an incomplete optimization output
#be careful with the number of lines hardcoded to 500.
#that means maximum number of atoms is 490 or so, perhaps there is also a minimum.

#input, output, charge and multiplicity provided
if [ $1 ] && [ $2 ] && [ $3 ] && [ $4 ]; then
  outfile=$1
  target=$2
  chrg=$3
  mult=$4
  echo "Using case 1: $outfile $target $chrg $mult"
  echo "\$molecule" >$target
  echo "$chrg $mult" >>$target
  tac $outfile | grep "I     Atom           X                Y                Z" -m1 -B500 | tac | egrep -o [A-Z][a-z]*[" "]+[-]*[0-9]+[.][0-9]+[" "]+[-]*[0-9]+[.][0-9]+[" "]+[-]*[0-9]+[.][0-9]+ >>$target
  echo "\$end" >>$target
#input, charge and multiplicit provided, output from name of input file
elif [ $1 ] && [ $2 ] && [ $3 ]; then
  outfile=$1
  chrg=$2
  mult=$3
  target=$(echo $outfile | sed s/.out/_last.mol/)
  echo "Using case 2: $outfile $target $chrg $mult"
  echo "\$molecule" >$target
  echo "$chrg $mult" >>$target
  tac $outfile | grep "I     Atom           X                Y                Z" -m1 -B500 | tac | egrep -o [A-Z][a-z]*[" "]+[-]*[0-9]+[.][0-9]+[" "]+[-]*[0-9]+[.][0-9]+[" "]+[-]*[0-9]+[.][0-9]+ >>$target
  echo "\$end" >>$target
#only input and output provided, assume neutral and closed shell molecule
elif [ $1 ] && [ $2 ]; then
  outfile=$1
  target=$2
  chrg=0
  mult=1
  echo "Using case 3: $outfile $target $chrg $mult"
  echo "\$molecule" >$target
  echo "$chrg $mult" >>$target
  tac $outfile | grep "I     Atom           X                Y                Z" -m1 -B500 | tac | egrep -o [A-Z][a-z]*[" "]+[-]*[0-9]+[.][0-9]+[" "]+[-]*[0-9]+[.][0-9]+[" "]+[-]*[0-9]+[.][0-9]+ >>$target
  echo "\$end" >>$target
#only input provided, assume neutral and closed shell molecule, output from name of input file
elif [ $1 ]; then
  outfile=$1
  chrg=0
  mult=1
  target=$(echo $outfile | sed s/.out/_last.mol/)
  echo "Using case 4: $outfile $target $chrg $mult"
  echo "\$molecule" >$target
  echo "$chrg $mult" >>$target
  tac $outfile | grep "I     Atom           X                Y                Z" -m1 -B500 | tac | egrep -o [A-Z][a-z]*[" "]+[-]*[0-9]+[.][0-9]+[" "]+[-]*[0-9]+[.][0-9]+[" "]+[-]*[0-9]+[.][0-9]+ >>$target
  echo "\$end" >>$target
else
  echo "This script needs 1-4 arguments (outputfile [[targetfile]] [charge multiplicity])"
fi

echo "Done."
