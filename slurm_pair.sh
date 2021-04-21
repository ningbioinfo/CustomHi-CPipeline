#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --time=30:00:00
#SBATCH --mem=50GB
#SBATCH --gres=tmpfs:150G

# Notification configuration
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=ning.liu@adelaide.edu.au


module load arch/haswell
module load SAMtools
module load pigz
source activate pairtools

# 1st is the bam, 2nd is chrsize file, 3rd is threads 4th is outputdir
bash pairtools_pair.sh $1 $2 $3 $4
