#!/bin/bash

mkdir MOs MP2 STATE_DENS TRANS_DENS

mv mo.* MOs
mv *mp2* MP2
mv *dens.cube STATE_DENS
mv *trans.cube TRANS_DENS

for i in *_attach.cube 
	do j=$(echo $i | sed s/attach/4attach/)
	mv $i $j 
done

for i in *_detach.cube 
	do j=$(echo $i | sed s/detach/2detach/)
	mv $i $j 
done

for i in *_elec.cube 
	do j=$(echo $i | sed s/elec/3elec/)
	mv $i $j 
done

for i in *_hole.cube 
	do j=$(echo $i | sed s/hole/1hole/)
	mv $i $j 
done

for i in *_diff.cube 
	do j=$(echo $i | sed s/diff/5diff/)
	mv $i $j 
done

