#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --time=30:00:00
#SBATCH --mem=8GB

# Notification configuration
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=ning.liu@adelaide.edu.au

module load arch/haswell
module load FastQC
module load pigz

RAW_DATA_DIR=$1
NAME=$2

cd ${RAW_DATA_DIR}

zcat *_R1.fastq.gz | pigz -p 16 -c > ${NAME}_R1.fastq.gz.good
zcat *_R2.fastq.gz | pigz -p 16 -c > ${NAME}_R2.fastq.gz.good

#rm *_R1.fastq.gz
#rm *_R2.fastq.gz

mv ${NAME}_R1.fastq.gz.good ${NAME}_R1.fastq.gz
mv ${NAME}_R2.fastq.gz.good ${NAME}_R2.fastq.gz

if [ ! -f ${RAW_DATA_DIR}/${NAME}_R1_fastqc.zip ]; then fastqc --threads 8 ${NAME}_R1.fastq.gz; fi;
if [ ! -f ${RAW_DATA_DIR}/${NAME}_R2_fastqc.zip ]; then fastqc --threads 8 ${NAME}_R2.fastq.gz; fi;
