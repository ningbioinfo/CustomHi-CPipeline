#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --time=10:00:00
#SBATCH --mem=100GB
#SBATCH --gres=tmpfs:100G

# Notification configuration
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=ning.liu@adelaide.edu.au

module load arch/haswell

source activate metahic

index=$1
fastq1=$2
fastq2=${fastq1/_R1/_R2}
prefix=$(basename ${fastq1} _R1.fastq.gz)
map_out=$3

bwa mem -t 32 -SP5M ${index} ${fastq1} ${fastq2} > ${map_out}/${prefix}.sam

samtools sort -m 2G -@ 32 -n ${map_out}/${prefix}.sam > ${map_out}/${prefix}_sortedn.bam

samtools flagstat --threads 16 ${map_out}/${prefix}_sortedn.bam > ${map_out}/${prefix}_sortedn.bam.flagstat

rm ${map_out}/${prefix}.sam

#rm ${fastq1}
#rm ${fastq2}
