#!/bin/bash
#SBATCH --job-name=qualimap
## Define the number of tasks
#SBATCH --ntasks=16
## Define the execution time limit
#SBATCH --time=24:30:00
## Define 12Go of memory per cpu
#SBATCH --mem-per-cpu=12G
#SBATCH --account=agap
#SBATCH --partition=agap_normal

module load qualimap/2.2.2

qualimap bamqc -nt 16 -outdir bamqcLM2Tpa120G -bam \
/home/carrettec/freePalm/couverture/couv_LM2Tpa_LM2/align_LM2Tpa_LM2.sorted.bam --java-mem-size=120G
#/home/carrettec/freePalm/couverture/couv_LM2/align_LM2Tp_LM2.sorted.bam



seff $SLURM_JOB_ID
