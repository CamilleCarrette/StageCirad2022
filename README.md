# StageCirad2022

Développement de chaînes de traitement de détection de zones de recombinaisons pour un assemblage de génome haplotype résolu

## Table des matières

1. [Assemblage Hifiasm](#assemblage-hifiasm)
2. [Alignements des assemblages et Dotplot](#alignements-des-assemblages-et-Dotplot)
3. [Analyses de qualité des assemblages](#analyses-de-qualité-des-assemblages)
4. [Alignement des lectures PacBio sur les assemblages](#alignement-des-lectures-PacBio-sur-les-assemblages)
5. [Exploitation de la carte génétique](#exploitation-de-la-carte-génétique)
6. [FAQs](#faqs)

## Assemblage Hifiasm

Script de production d'assemblages primaire et alternatif à partir de lectures PacBio Hifi [Hifiasm](https://github.com/chhylp123/hifiasm) :

```
hifiasm -o asm --primary -t 12 lecturesPacBio.fastq.gz
```

Extraction des fasta à partir des sorties Hifiasm :

```
awk '/^S/{print ">"$2;print $3}' ${path}asm.p_ctg.gfa |fold > asm.p_ctg.fna
awk '/^S/{print ">"$2;print $3}' ${path}asm.a_ctg.gfa |fold > asm.a_ctg.fna
```

## Alignements des assemblages et Dotplot 

Script sbatch d'execution de [minimap2](https://github.com/lh3/minimap2) pour la production de fichier d'alignement au format PAF :

```
minimap2 -t 4 asm.p_ctg.fna asm.a_ctg.fna > align_asm_p_asm_a.paf
```

Script [pafr](https://github.com/dwinter/pafr) de production du dotplot à partir du fichier PAF

```
library(pafr)

ali<-read_paf(“align_asm_p_asm_a.paf")
dotplot(
  ali, //objet fournit par “read_paf”
  order_by = "qstart", //ordre des alignements
  label_seqs = FALSE, //noms des contigs/chromosomes
  dashes = TRUE,  //délimitation des contigs/chromosomes
  alignment_colour = "red",
  xlab = "asm_p", //noms de l’axe X
  ylab = "asm_a",//noms de l’axe Y
  line_size = 2 //Taille des alignements
)
```

Exemple de dotplot :

![exemplePlot](https://user-images.githubusercontent.com/41194534/176865783-1f48367a-2014-4cfc-bfd1-17173f973e67.png)

## Analyses de qualité des assemblages 

Script [Quast](https://github.com/ablab/quast) pour la production de statistiques sur les assemblages :

```
quast.py -o quast_asm_p -t 16 asm.p_ctg.fna
```

Script [BUSCO](https://github.com/WenchaoLin/BUSCO-Mod) de statistique de complétude des gènes universels dans la famille liliopsida d'un assemblage séquences :

```
busco -m genome -i asm.p_ctg.fna -o busco_asm_p -c 16 -l liliopsida_odb10 
```

## Alignement des lectures PacBio sur les assemblages

Script de production d'un fichier d'alignement SAM :

```
minimap2 -ax map-hifi -t 8 asm.p_ctg.fna lecturesPacBio.fastq.gz > align_asm_p_lectures.sam
```

Utilisation de [samtools](https://github.com/samtools/samtools) pour la conversion en BAM, le tri du BAM ainsi que la production de fichier d'index :

```
samtools fixmate align_asm_p_lectures.sam align_asm_p_lectures.bam
samtools sort -l 1 -@ 8 align_asm_p_lectures.bam align_asm_p_lectures.sorted
samtools index align_asm_p_lectures.sorted.bam
```

Métriques de qualités de l'alignement des lectures avec [qualimap](https://github.com/scchess/Qualimap) :

```
qualimap bamqc -nt 16 -outdir bamqc_align_asm_p_lectures -bam align_asm_p_lectures.sorted.bam --java-mem-size=120G
```

Appel de variants (VCF) à partir des BAM avec [sniffles](https://github.com/fritzsedlazeck/Sniffles) : 

```
sniffles --threads 8 --input align_asm_p_lectures.sorted.bam --vcf align_asm_p_lectures.vcf
```

Exemple de visualisation avec [IGV](https://software.broadinstitute.org/software/igv/) des fichier BAM et VCF : 


![exempleIGVGitHub](https://user-images.githubusercontent.com/41194534/176867637-d9b4ef6a-689a-4913-b778-52ee0ca0fea0.png)

## Exploitation de la carte génétique

Extraction de bloc haplotypique à partir de fichier de sortie [Lep-MAP3](https://sourceforge.net/projects/lep-map3/) au format csv tel que :

|ID|LG|markerNbr|cM|contig|pos|LM1_H1|LM1_H2|
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
|AX-179402702|1|5037|29.988|ptg000059l|7532919|1|1|
|AX-169795776|1|5031|30.341|ptg000059l|7301632|1|1|
|AX-179467189|1|5032|30.494|ptg000059l|7343117|1|1|
|AX-179467187|1|5033|31.57|ptg000059l|7348123|1|0|
|AX-323011188|1|5030|32.078|ptg000059l|7193991|1|0|
|AX-179402699|1|5029|32.23|ptg000059l|7166911|1|0|

```
 python3 haploBlock.py sortieLepMAP.csv
```

## Ancrage de l'assemblage 

En développement.
