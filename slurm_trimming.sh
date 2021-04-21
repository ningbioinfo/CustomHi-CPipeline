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
module load AdapterRemoval

data=$1
TRIM_DIR=$2
name=$(basename ${data} _R1.fastq.gz)

AdapterRemoval --qualitymax 93 --file1 ${data} --file2 ${data/_R1/_R2} --basename ${TRIM_DIR}/${name} --trimns --trimqualities --collapse --gzip --threads 16

mv ${TRIM_DIR}/${name}.pair1.truncated.gz ${TRIM_DIR}/${name}_trimmed_R1.fastq.gz
mv ${TRIM_DIR}/${name}.pair2.truncated.gz ${TRIM_DIR}/${name}_trimmed_R2.fastq.gz

rm ${TRIM_DIR}/${name}.collapsed.gz
#rm ${data}
#rm ${data/_R1/_R2}
