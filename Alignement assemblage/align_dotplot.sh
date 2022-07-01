#!/bin/bash
#SBATCH --job-name=align_dotplot
#SBATCH --ntasks=4
#SBATCH --time=248:00:00
#SBATCH --mem-per-cpu=100G
#SBATCH --account=agap
#SBATCH --partition=agap_bigmem

module load minimap2/2.2.22-bin
module load R/4.0.2
module load R/packages/4.0.2

mkdir $3/
cd $3/

name1=$1
name1="${name1##*/}"
name1="${name1%.*}"

name2=$2
name2="${name2##*/}"
name2="${name2%.*}"

echo ----------------------Alignement-------------------------------------
minimap2 -t 4 $1 $2 > $3.paf
echo ------------------------Plot-----------------------------------------
Rscript /home/carrettec/scripts/dotPlot.R $3.paf $name1 $name2
echo ---------------------------------------------------------------------


seff $SLURM_JOB_ID
