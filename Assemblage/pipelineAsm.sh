#!/bin/bash
#SBATCH --job-name=asmpipe
## Define the number of tasks
#SBATCH --ntasks=12
## Define the execution time limit
#SBATCH --time=00:30:00
## Define 12Go of memory per cpu
#SBATCH --mem-per-cpu=120G
#SBATCH --account=agap
#SBATCH --partition=agap_bigmem

module load hifiasm/0.16.1
module load quast/5.1.0rc1
module load busco/5.3.1

#usage
#pipelineAsm.sh [fileIn] [fileOut] [dirOut]

mkdir $3
cd $3/

echo "-----------Lancement de l'assemblage--------------"
hifiasm -o $2 --primary -t 12 $1
echo "--------------------------------------------------"

awk '/^S/{print ">"$2;print $3}' $2.p_ctg.gfa |fold > $2.p_ctg.fna
awk '/^S/{print ">"$2;print $3}' $2.a_ctg.gfa |fold > $2.a_ctg.fna

busco -m genome -i $2.p_ctg.fna -o busco_results -c 12 -l liliopsida_odb10 --download_path /lustre/carrettec/busco/busco_downloads
busco -m genome -i $2.a_ctg.fna -o busco_results -c 12 -l liliopsida_odb10 --download_path /lustre/carrettec/busco/busco_downloads

echo "-----------Lancement du quast sur les deux assemblages------------"
quast.py -o quast_results -t 12 $2.p_ctg.fna $2.a_ctg.fna
echo "------------------------------------------------------------------"
