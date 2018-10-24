#!/bin/bash

natoms=0
nelec=0

if [ $(grep -o "Z-matrix" t1opt.out) ] ; then 

cp /data/mewes/CALC/TADF/MOM_OPT/utleopt*in MOM_OPT

sed "s/^0 1$/0 3/" t1opt.mol > MOM_OPT/utLEincoords.mol

cd MOM_OPT

for i in utleopt*in ; do 
 subqchem_old $i 
done

cd -

else echo "t1opt not converged."
fi
