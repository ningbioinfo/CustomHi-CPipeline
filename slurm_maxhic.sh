#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --time=5:00:00
#SBATCH --mem=32GB

# Notification configuration
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=ning.liu@adelaide.edu.au

module load arch/haswell
module load pigz
module load Anaconda3/2019.03

source activate maxhic

name=$1
ROOTDIR=$2
MAXDIR=${ROOTDIR}/${name}_out/maxhic30
OUTROOT=$3
OUTDIR=${OUTROOT}/${name}_out/maxhic30_out
CHECK=$4
TOCHECK=${name},
TYPE=$(grep ^${TOCHECK} ${CHECK} | cut -f2 -d ',')
STUDY=$(grep ${TOCHECK} ${CHECK} | cut -f12 -d ',')

#echo ${TYPE}
echo "type of sample ${name} is ${TYPE}.."

mkdir -p $OUTDIR

if [[ ${TYPE} == "CHi-C" ]] ;
then
  BAITFILE=/hpcfs/users/a1692215/metahic/captureBait/${STUDY}_cb.bed
  echo ${BAITDIR}
  python /hpcfs/users/a1692215/metahic/MaxHiC/Main.py --capture T -bd ${BAITFILE} ${MAXDIR} ${OUTDIR} -t 16 &> ${OUTDIR}/${name}_10kb_maxhic.log
  rm ${OUTDIR}/oo*txt
  pigz -p 16 ${OUTDIR}/*_interactions.txt
elif [[ ${TYPE} == "Hi-C" ]] ;
then
  echo "running in Hi-C mode.."
  python /hpcfs/users/a1692215/metahic/MaxHiC/Main.py ${MAXDIR} ${OUTDIR} -t 16 &> ${OUTDIR}/${name}_10kb_maxhic.log
  pigz -p 16 ${OUTDIR}/*_interactions.txt
fi
