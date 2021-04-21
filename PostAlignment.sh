#!/bin/bash

# script that is post alignment

# first we process bam file to pair files using pairtools

# then we process pair files to raw matrix and norm matrix and their bin bed file

# input is the sample name
INPUT=$1
# check is a csv file with sample name is 1st column and hic type as 2nd, sep by comma
CHECK=$2
THREADS=$3
RES=$4
OUTDIR=$5
map_job_id=$6 # used zero if there is no mapping job before
TOCHECK=${INPUT},
TYPE=$(grep ${TOCHECK} ${CHECK} | cut -f2 -d ',')
ORGANISM=$(grep ${TOCHECK} ${CHECK} | cut -f3 -d ',')
# type would be either Hi-C or CHi-C
BAM=${OUTDIR}/${INPUT}_out/mapped_data/${INPUT}_trimmed_sortedn.bam
PAIRDIR=${OUTDIR}/${INPUT}_out/pair30
COOLDIR=${OUTDIR}/${INPUT}_out/cool30
MAXDIR=${OUTDIR}/${INPUT}_out/maxhic30
MAXOUTDIR=${OUTDIR}/${INPUT}_out/maxhic30_out
mkdir -p ${PAIRDIR}
mkdir -p ${COOLDIR}
mkdir -p ${MAXDIR}
mkdir -p ${MAXOUTDIR}


if [[ ${ORGANISM} == Homo* ]] ;
then
  SIZEFILE=/hpcfs/users/a1692215/metahic/Genomes/hg38.sizes
elif [[ ${ORGANISM} == Mus* ]] ;
then
  SIZEFILE=/hpcfs/users/a1692215/metahic/Genomes/mm10.sizes
elif [[ ${ORGANISM} == Gallus* ]] ;
then
  SIZEFILE=/hpcfs/users/a1692215/metahic/Genomes/GRCg6a.sizes
  CAP=/data/robinson/190430_Ning_metaHiC/HiCWorkFlow_out/captureBait/mm10_capture_baits.bed
elif [[ ${ORGANISM} == Capra* ]] ;
then
  SIZEFILE=/hpcfs/users/a1692215/metahic/Genomes/ARS1.sizes
  CAP=/data/robinson/190430_Ning_metaHiC/HiCWorkFlow_out/captureBait/mm10_capture_baits.bed
elif [[ ${ORGANISM} == Sus* ]] ;
then
  SIZEFILE=/hpcfs/users/a1692215/metahic/Genomes/Sscrofa11.sizes
  CAP=/data/robinson/190430_Ning_metaHiC/HiCWorkFlow_out/captureBait/mm10_capture_baits.bed
fi

echo "Mapping job id is ${map_job_id}"
sbatch --dependency=afterok:${map_job_id} slurm_pair.sh ${BAM} ${SIZEFILE} ${THREADS} ${PAIRDIR} > tempfile
PAIR=${PAIRDIR}/${INPUT}.valid.pairs.gz
pair_job_id=$(head -n1 tempfile | cut -d ' ' -f4)
rm tempfile

sbatch --dependency=afterok:${pair_job_id} slurm_cool.sh ${PAIR} ${COOLDIR} ${SIZEFILE} ${RES} ${MAXDIR} ${THREADS} > tempfile
cool_job_id=$(head -n1 tempfile | cut -d ' ' -f4)
rm tempfile

sbatch --dependency=afterok:${cool_job_id} slurm_maxhic.sh ${INPUT} ${OUTDIR} ${OUTDIR} ${CHECK} 
