#!/bin/bash

mult="adc"

mkdir MOs MP2 STATE_DENS TRANS_DENS

mv mo.* MOs
mv *mp2* MP2
mv *dens.cube STATE_DENS
mv *trans.cube TRANS_DENS

for i in singlet*_attach.cube 
	do j=$(echo $i | sed "s/attach/sing_4att/" | sed s/singlet_//)
	mv $i $j 
done

for i in singlet*_detach.cube 
	do j=$(echo $i | sed "s/detach/sing_2det/"| sed s/singlet_//)
	mv $i $j 
done

for i in singlet*_diff.cube 
	do j=$(echo $i | sed "s/diff/sing_5dif/"| sed s/singlet_//)
	mv $i $j 
done

for i in singlet*_elec.cube 
	do j=$(echo $i | sed "s/elec/sing_3ele/"| sed s/singlet_//)
	mv $i $j 
done

for i in singlet*_hole.cube 
	do j=$(echo $i | sed "s/hole/sing_1hol/"| sed s/singlet_//)
	mv $i $j 
done

for i in triplet*_attach.cube 
	do j=$(echo $i | sed "s/attach/trip_4att/"| sed s/triplet_//)
	mv $i $j 
done

for i in triplet*_detach.cube 
	do j=$(echo $i | sed "s/detach/trip_2det/"| sed s/triplet_//)
	mv $i $j 
done

for i in triplet*_diff.cube 
	do j=$(echo $i | sed "s/diff/trip_5dif/"| sed s/triplet_//)
	mv $i $j 
done

for i in triplet*_elec.cube 
	do j=$(echo $i | sed "s/elec/trip_3ele/"| sed s/triplet_//)
	mv $i $j 
done

for i in triplet*_hole.cube 
	do j=$(echo $i | sed "s/hole/trip_1hol/"| sed s/triplet_//)
	mv $i $j 
done


