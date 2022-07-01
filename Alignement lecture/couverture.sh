#!/bin/bash
#SBATCH --job-name=couverture
## Define the number of tasks
#SBATCH --ntasks=8
## Define the execution time limit
#SBATCH --time=248:00:00
## Define 24G of memory per cpu
#SBATCH --mem-per-cpu=100G
#SBATCH --account=agap
#SBATCH --partition=agap_bigmem

module load minimap2/2.2.22-bin
module load samtools/1.2
module load qualimap/2.2.2

#usage
#minimap2 [ref] [reads] [nomAlign]

#extraction du nom du fichier
mkdir couv_$3
cd couv_$3
echo "-----------minimap2-----------------"
minimap2 -ax map-hifi -t 8 $1 $2 > $3.sam
echo "------------------------------------"

echo "-------------production sorted.bam+index-----------------"
samtools fixmate $3.sam $3.bam
samtools sort -l 1 -@ 8 $3.bam $3.sorted
samtools index $3.sorted.bam
echo "---------------------------------------------------------"

echo "----------------------VCF---------------------------------"
sniffles --threads 8 --input $3.sorted.bam --vcf $3.vcf
echo "---------------------------------------------------------"

echo "---------------------qualimap----------------------------"
qualimap bamqc -nt 8 -outdir bamqc_$3 -bam $3.sorted.bam --java-mem-size=120G
echo "---------------------------------------------------------"

seff $SLURM_JOB_ID
