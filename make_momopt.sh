#!/bin/bash

natoms=0
nelec=0

if [ $(grep -o "Z-matrix" gsopt.out) ] ; then 

mkdir MOM_OPT
cp /data/mewes/CALC/TADF/MOM_OPT/*1*in MOM_OPT

nelec=$(grep electrons gsopt.out -m1 | awk '{print $3}') 
alpha=$(seq -s " " $((nelec+1)) | sed "s/$nelec//")
beta=$(seq -s " " $nelec)

for i in MOM_OPT/moms1opt*in ; do
	sed -i "s/OCCU/$alpha/" $i
	sed -i "s/VIRT/$beta/" $i 
done

cp s1opt.mol MOM_OPT/incoords.mol 
sed "s/^0 1$/0 3/" s1opt.mol > MOM_OPT/uincoords.mol

cd MOM_OPT

for i in *in ; do 
 subqchem_old $i 
done

cd -

else echo "Gsopt not converged."
fi
