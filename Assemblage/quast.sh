#!/bin/bash
#SBATCH --job-name=quast
## Define the number of tasks
#SBATCH --ntasks=16
## Define the execution time limit
#SBATCH --time=00:30:00
## Define 12Go of memory per cpu
#SBATCH --mem-per-cpu=12G
#SBATCH --account=agap
#SBATCH --partition=agap_normal

module load quast/5.1.0rc1

quast.py -o $2 -t 16 $1

seff $SLURM_JOB_ID
