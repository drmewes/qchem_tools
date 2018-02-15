#!/bin/bash
if [ $1 ] ; then 
	[ $1 = "sub" ] && action=true 
fi


if [ $action ]; then
echo "Checking and resubmitting if failed..."
for  i in *in 
	do j=$(echo $i | sed s/in/out/ ) 
	   k=$(echo $i | sed s/in/sh/)
 	test=$(tail -n50 $j | grep -o Thank )
	if [ "$test" == "Thank" ] 
		then echo "$i CONVERGED" 
		else echo -n "$i NOT CONVERGED..."
                job=$(echo $i | sed "s/.in//")
		job=$(pwd | sed 's/\/home\/mewes\/CALC\///' | sed 's/\//./' | sed 's/\//./' | sed 's/\//./' | sed 's/\//./' | sed 's/\//./' | sed 's/\//./' | sed 's/\//./' ).$job
                id=$(squeue -o "%.10i %.5P %.3C %.3m %.128j %.8u %.2t %.11M %.11l %16R" -u mewes | grep $job | awk '{print $1}')
                state=$(squeue -o "%.10i %.5P %.3C %.3m %.128j %.8u %.2t %.11M %.11l %16R" -u mewes | grep $job | awk '{print $7}')
                node=$(squeue -o "%.10i %.5P %.3C %.3m %.128j %.8u %.2t %.11M %.11l %16R" -u mewes | grep $job | awk '{print $10}')
                
if [ ! "$id" = "" ] ; then
                echo " but FOUND IN QUE with state $state and id $id on node $node."
		else
		echo " and NOT FOUND IN QUE, resubmitting... "
		sbatch $k 
		fi
	fi  
done 
else 
echo "Just checking..."
for  i in *in 
        do j=$(echo $i | sed s/in/out/ ) 
           k=$(echo $i | sed s/in/sh/)
        test=$(tail -n50 $j | grep -o Thank )
        if [ "$test" == "Thank" ] 
                then echo "$i CONVERGED" 
                else echo -n "$i NOT CONVERGED..."
		job=$(echo $i | sed "s/.in//")
                job=$(pwd | sed 's/\/home\/mewes\/CALC\///' | sed 's/\//./' | sed 's/\//./' | sed 's/\//./' | sed 's/\//./' | sed 's/\//./' | sed 's/\//./' | sed 's/\//./' ).$job
                id=$(squeue -o "%.10i %.5P %.3C %.3m %.128j %.8u %.2t %.11M %.11l %16R" -u mewes | grep $job | awk '{print $1}')
                state=$(squeue -o "%.10i %.5P %.3C %.3m %.128j %.8u %.2t %.11M %.11l %16R" -u mewes | grep $job | awk '{print $7}')
                node=$(squeue -o "%.10i %.5P %.3C %.3m %.128j %.8u %.2t %.11M %.11l %16R" -u mewes | grep $job | awk '{print $10}')
		if [ ! "$id" = "" ] ; then
                	echo " but FOUND IN QUE with state $state and id $id on node $node."
                else
                	echo " and NOT FOUND IN QUE."
		fi        
	fi  
done 
fi

