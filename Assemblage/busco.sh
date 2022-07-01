#!/bin/bash
#SBATCH --job-name=busco
## Define the number of tasks
#SBATCH --ntasks=16
## Define the execution time limit
#SBATCH --time=48:00:00
## Define 12G of memory per cpu
#SBATCH --mem-per-cpu=12G
#SBATCH --account=agap
#SBATCH --partition=agap_normal

module load busco/5.3.1

busco -m genome -i $1 -o $2 -c 16 -l liliopsida_odb10 

seff $SLURM_JOB_ID
