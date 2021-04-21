#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --time=10:00:00
#SBATCH --mem=32GB
#SBATCH --gres=tmpfs:150G

# Notification configuration
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=ning.liu@adelaide.edu.au

module load arch/haswell
source activate cooler

bash cooler_matrix.sh $1 $2 $3 $4 $5 $6
