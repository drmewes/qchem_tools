#!/bin/bash
# PBS Job
#PBS -V
#PBS -N Na-liq-1069
#PBS -m ae
#PBS -q batch
#PBS -l nodes=1:ppn=28
# 

cd $PBS_O_WORKDIR
export PATH=/home/abt-grimme/AK-bin:$PATH
export PATH=/home/$USER/bin:$PATH

export HOSTS_FILE=$PBS_NODEFILE
cat $HOSTS_FILE>hosts_file

TMP_DIR=/tmp1/$USER
DIR1=$PWD


startzeit=`date +%s`

mpirun -np 28 vasp_current > output  

endzeit=`date +%s`

runtime=$((endzeit-startzeit))
minutetime=$(bc <<<"scale=2 ; $runtime/60")
hourtime=$(bc <<<"scale=2 ; $runtime/3600")
daytime=$(bc <<<"scale=2 ; $runtime/86400")
echo $runtime' s' > zeit
echo $minutetime' min' >> zeit
echo $hourtime' h' >> zeit
echo $daytime' days' >> zeit

#end of job      (....and stop editing here.)

