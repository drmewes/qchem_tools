#!/bin/bash

#This script extracts and prints excited state energies and properties
#from all output files in the folder. It works only for ADC/SS-PCM excited-state
#solvent-field equilibrations.

isref=""

echo -e "Molecule.Solvent \t| Multipl | Energy   | nm  | fosc.    | ES-Dipole | RMS e-h"
for j in *out; do
  echo ""
  #echo $j
  nstates=$(tac $j | grep -m 1 ee_states | awk '{print $2}')
  if [ -z "$nstates" ]; then
    nsinglets=$(tac $j | grep -m 1 ee_singlets | awk '{print $2}')
    ntriplets=$(tac $j | grep -m 1 ee_triplets | awk '{print $2}')
    if [ -n "$ntriplets" ] && [ -n "$nsinglets" ]; then
      nstates=$(echo "$nsinglets+$ntriplets" | bc)
    elif [ -n "$nsinglets" ]; then
      nstates=$nsinglets
    elif [ -n "$ntriplets" ]; then
      nstates=$ntriplets
    else
      echo "No ES found"
      break
    fi
  fi
  #echo "Going for $nstates states"
  for i in $(seq $nstates); do
    energy=$(tac $j | egrep "Excited state"[" "]\*"$i " -B 10 -m1 | grep -e "Emission energy (PCM 1st order," | awk '{print $8}') && isref="EQS-REFERENCE"
    [ -z $energy ] && energy=$(tac $j | egrep "Excited state"[" "]\*"$i " -B 10 -m1 | grep -e "Formal excitation" | awk '{print $7}') && isref=""
    fosc=$(tac $j | egrep "Excited state"[" "]\*"$i " -B 20 -m1 | grep "Osc." | awk '{print $3}')
    mult=$(tac $j | egrep "Excited state"[" "]\*"$i " -B 1 -m1 | grep -o -e "singlet" -e "triplet")
    irrep=$(tac $j | egrep "Excited state"[" "]\*"$i " -B 10 -m1 | grep Term | awk '{print $3 $4 $5}')
    es_dip=$(tac $j | egrep "Excited state"[" "]\*"$i " -B 30 -m1 | grep "Total dipole" | awk '{print $4}')
    rms_ehs=$(tac $j | egrep "Excited state"[" "]\*"$i " -B 200 -m1 | grep "RMS" | awk '{print $5}')
    if [ -z "$fosc" ]; then
      fosc=0.000000
    fi
    if [ -z "$energy" ]; then
      energy=NOT_CONV
      fosc=NOT_CONV
      es_dip=NOT_CONVE
      rms_ehs=NOT_CONV
      nano=NOC
    else
      nano=$(echo "1240/$energy" | bc)
    fi
    echo -e "$j    \t| $mult | $energy | $nano | $fosc | $es_dip | $rms_ehs | $isref"
  done
done
