#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --time=10:00:00
#SBATCH --mem=8GB

# Notification configuration
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=ning.liu@adelaide.edu.au

# download data

module load arch/haswell
module load FastQC

source activate aspera

URL1=$1
URL2=${URL1/_1/_2}
RAW_DATA_DIR=$2
NAME=$3

ascp -QT -l 300m -P33001 -i /hpcfs/users/a1692215/metahic/metaInit/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:${URL1} ${RAW_DATA_DIR}/${NAME}_R1.fastq.gz

ascp -QT -l 300m -P33001 -i /hpcfs/users/a1692215/metahic/metaInit/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:${URL2} ${RAW_DATA_DIR}/${NAME}_R2.fastq.gz

if [ ! -f ${RAW_DATA_DIR}/${NAME}_R1_fastqc.zip ]; then fastqc --threads 8 ${RAW_DATA_DIR}/${NAME}_R1.fastq.gz; fi;
if [ ! -f ${RAW_DATA_DIR}/${NAME}_R2_fastqc.zip ]; then fastqc --threads 8 ${RAW_DATA_DIR}/${NAME}_R2.fastq.gz; fi;
