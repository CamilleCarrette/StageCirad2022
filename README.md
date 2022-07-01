# StageCirad2022
Développement de chaînes de traitement de détection de zones de recombinaisons pour un assemblage de génome haplotype résolu

## Table of Contents
1. [Assemblage Hifiasm](#assemblage-hifiasm)
2. [Alignements des assemblages et Dotplot](#alignements-des-assemblages-et-Dotplot)
3. [Alignement des lectures PacBio sur les assemblages](#alignement-des-lectures-PacBio-sur-les-assemblages)
4. [Collaboration](#collaboration)
5. [FAQs](#faqs)

## Assemblage Hifiasm
Script de production d'assemblages primaire et alternatif à partir de lectures PacBio Hifi :

```
hifiasm -o asm --primary -t 12 lecturesPacBio.fastq.gz
```

Extraction des fasta à partir des sorties Hifiasm :

```
awk '/^S/{print ">"$2;print $3}' ${path}asm.p_ctg.gfa |fold > asm.p_ctg.fna
awk '/^S/{print ">"$2;print $3}' ${path}asm.a_ctg.gfa |fold > asm.a_ctg.fna
```

## Alignements des assemblages et Dotplot 
Script sbatch d'execution de minimap2 pour la production de fichier d'alignement au format PAF

```
minimap2 -t 4 asm.p_ctg.fna asm.a_ctg.fna > align_asm_p_asm_a.paf
```

Script R de production du dotplot à partir du fichier PAF

```
ali<-read_paf(“align_asm1_asm2.paf")
dotplot(
  ali, //objet fournit par “read_paf”
  order_by = "qstart", //ordre des alignements
  label_seqs = FALSE, //noms des contigs/chromosomes
  dashes = TRUE,  //délimitation des contigs/chromosomes
  alignment_colour = "red",
  xlab = "query", //noms de l’axe X
  ylab = "target",//noms de l’axe Y
  line_size = 2 //Taille des alignements
)
```

Exemple de dotplot :

![exemplePlot](https://user-images.githubusercontent.com/41194534/176865783-1f48367a-2014-4cfc-bfd1-17173f973e67.png)

## Alignement des lectures PacBio sur les assemblages
Script de production d'un fichier d'alignement SAM :

```
minimap2 -ax map-hifi -t 8 asm.p_ctg.fna lecturesPacBio.fastq.gz > align_asm_p_lectures.sam
```

Utilisation de samtools pour la conversion en BAM, le tri du BAM ainsi que la production de fichier d'index :

```
samtools fixmate align_asm_p_lectures.sam align_asm_p_lectures.bam
samtools sort -l 1 -@ 8 align_asm_p_lectures.bam align_asm_p_lectures.sorted
samtools index align_asm_p_lectures.sorted.bam
```

Appel de variants (VCF) à partir des BAM.

```
sniffles --threads 8 --input align_asm_p_lectures.sorted.bam --vcf align_asm_p_lectures.vcf
```

Exemple de visualisation avec IGV des fichier BAM et VCF : 


