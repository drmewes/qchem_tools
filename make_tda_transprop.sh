#!/bin/bash
echo "Copying template jobs and preparing mol files to calculate "
echo "transition properties for MOM structures at TDA/SS-PCM level..."
echo ""

for i in *out ; do
	qc2xyz.sh $i
done

cat moms1opt_vac.xyz moms1opt_chx.xyz moms1opt_tol.xyz moms1opt_eth.xyz moms1opt_dcm.xyz > sgeoms.xyz
cat ut1opt_vac.xyz ut1opt_chx.xyz ut1opt_tol.xyz ut1opt_eth.xyz ut1opt_dcm.xyz > tgeoms.xyz

cp -r /data/mewes/CALC/TADF/TRANSPROP . 

qc2mol.sh 

sed -i "s/^0 3$/0 1/" ut1*mol
cp *mol TRANSPROP

if [ "$1" = "sub" ] ; then 
	echo ""
	echo "Found flag to submit jobs, submitting now..."
	cd TRANSPROP
	for i in *in ; do 
 		subqchem_old $i 
	done
	cd -
	echo "All done!"
fi

