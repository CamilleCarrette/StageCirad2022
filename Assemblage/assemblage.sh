#!/bin/bash
#SBATCH --job-name=asm
## Define the number of tasks
#SBATCH --ntasks=12
## Define the execution time limit
#SBATCH --time=248:00:00
## Define 120Go of memory per cpu
#SBATCH --mem-per-cpu=120G
#SBATCH --account=agap
#SBATCH --partition=agap_bigmem

module load hifiasm/0.16.1
#script d'assemblage des individus LM
#hifiasm -o LM1/LM1 --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL1_CCS_demux.bc1002--bc1002.fastq.gz
#hifiasm -o LM2.asm --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL1_CCS_demux.bc1003--bc1003.fastq.gz
#hifiasm -o LM3/LM3.asm --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL1_CCS_demux.bc1008--bc1008.fastq.gz

hifiasm -o LM5/LM5.asm --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL2_CCS_demux.bc1002--bc1002.fastq.gz
hifiasm -o LM7/LM7.asm --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL2_CCS_demux.bc1003--bc1003.fastq.gz
hifiasm -o LM8/LM8.asm --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL2_CCS_demux.bc1008--bc1008.fastq.gz
hifiasm -o LM9/LM9.asm --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL3_CCS_demux.bc1010--bc1010.fastq.gz
hifiasm -o LM10/LM10.asm --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL3_CCS_demux.bc1011--bc1011.fastq.gz
hifiasm -o LM11/LM11.asm --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL3_CCS_demux.bc1012--bc1012.fastq.gz
hifiasm -o LM13/LM13.asm --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL4_CCS_demux.bc1010--bc1010.fastq.gz
hifiasm -o LM14/LM14.asm --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL4_CCS_demux.bc1011--bc1011.fastq.gz
hifiasm -o LM15/LM15.asm --primary -t 12 /lustre/agap/elaeis_guineensis/freepalm/data/EguL4_CCS_demux.bc1012--bc1012.fastq.gz

seff $SLURM_JOB_ID
