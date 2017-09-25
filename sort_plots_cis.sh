#!/bin/bash

mult="cis"

if [ $1 ] ; then
   if [ "$1" = "sing" ] || [ "$1" = "singlet" ] || [ "$1" = "1" ] ; then
        echo "Dealing with singlets..."
	mult="sing"
    elif [ "$1" = "trip" ] || [ "$1" = "triplet" ] || [ "$1" = "3" ]; then
        echo "Dealing with triplets..."
	mult="trip"
   fi
fi

rm mo.* 
rm *mp2* 
rm *dens.cube 
rm *trans.cube 
rm *_elec.cube
rm *_hole.cube

for i in *_attach.cube 
	do j=$(echo $i | sed "s/attach/${mult}_2att/")
	mv $i $j 
done

for i in *_detach.cube 
	do j=$(echo $i | sed "s/detach/${mult}_1det/")
	mv $i $j 
done

for i in *_diff.cube 
	do j=$(echo $i | sed "s/diff/${mult}_3dif/")
	mv $i $j 
done

