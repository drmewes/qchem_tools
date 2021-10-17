#!/bin/bash

natoms=0

for i in *out; do
  if [ $(grep -o "Z-matrix" $i) ]; then
    molfile=$(echo $i | sed 's/.out/.mol/')
    if [ $(grep "Nuclear Repulsion Energy =" -b2 $i | head -n 1 | awk '{print $2}') = "Molecular" ]; then
      echo "Symmetry detected"
      natoms=$(grep "Nuclear Repulsion Energy =" -b4 $i | head -n 1 | awk '{print $2}')
    else
      natoms=$(grep "Nuclear Repulsion Energy =" -b2 $i | head -n 1 | awk '{print $2}')
    fi
    headlines=$((natoms + 4))
    taillines=$((natoms + 3))
    grep "Z-matrix" $i -A1000 | head -n $headlines | tail -n $taillines >$molfile
    echo "$i: Extracted optimized structure ($natoms atoms) to $molfile"
  else
    echo "$i: No optimized structure found"
  fi
done
