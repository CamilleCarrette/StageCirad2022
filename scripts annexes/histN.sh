#!/bin/bash
#SBATCH --job-name=histN
## Define the number of tasks
#SBATCH --ntasks=5
## Define the execution time limit
#SBATCH --time=00:30:00
## Define 12Go of memory per cpu
#SBATCH --mem-per-cpu=24G
#SBATCH --account=agap
#SBATCH --partition=agap_normal

module load R/4.0.2
module load R/packages/4.0.2 
#usage
#histN.sh [fastaIn] [dataOutFile] [nbrDecoupage]
#exemple : histN.sh Chr6_GK000081.1.fasta NChr6.txt 100

echo "récupération de la sequence"
seq=$(grep -v '>' $1) #récupération de la seq sans l'entete
nbCharSeq=$(wc -m < $1) #comptage des caractère de $1
nbrDecoupage=$3 #recup du nombre de découpage
fenetre=$(expr $nbCharSeq / $nbrDecoupage) #creation de la fenetre (taille des morceaux de seq)
echo "posDebut" "posFin" "nbrN" > $2 #création et header du fichier de sortie
debut=0
file=${1##*/}
$(mkdir tmp) #création du fichier temporaire
echo "Remplissage du fichier out"
for ((i=0 ; i < $nbrDecoupage ; i++)); do #autant de fois que de morceaux
    fin=$(expr $debut + $fenetre) #on fixe la fin du morceau
    currentSeq="tmp/"$file"-subseq.tmp" #nom du fichier temporaire courant
    echo ${seq:$debut:$fenetre} > $currentSeq #extraction d'un morceau depuis debut sur fenetre caractère
    NbrN=$(grep -o 'N' $currentSeq | wc -l) #comptage du nombre de N dans le fichier tmp
    echo $debut $fin $NbrN >> $2 #écriture dans le fichier de sortie
    debut=$fin #fixation du nouveau début
done
#dernier passage pour s'assurer d'avoir les derniers caractère (cas ou la division pour créer fenetre à un reste)

fin=$nbCharSeq #pour aller jusqu'au bout
currentSeq="tmp/last.tmp" #pour debuggage
echo ${seq:$debut:$(expr $fin - $debut)} > $currentSeq #extraction
NbrN=$(grep -o 'N' $currentSeq | wc -l) #comptage
echo $debut $fin $NbrN >> $2 #dernière entrée
rm $currentSeq
$(rm -rf tmp) #suppression du dossier tmp*
echo "Lancement du script R"
Rscript /home/carrettec/scripts/histN.R $2 ${1##*/}
