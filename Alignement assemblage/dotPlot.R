#dependencies
#devtools::install_github("dwinter/pafr", lib="/home/carrettec/scratch/aln/lib")
lib <- "/home/carrettec/scratch/aln/lib"
#install.packages('gridExtra', lib=lib,repos = "http://cran.us.r-project.org")
#install.packages('cowplot', lib=lib,repos = "http://cran.us.r-project.org")
library(cowplot,quietly=TRUE, lib.loc=lib)
library(gridExtra, quietly=TRUE, lib.loc=lib)
library(ellipsis, quietly=TRUE, lib.loc=lib)
library(rlang, quietly=TRUE, lib.loc=lib)
library(vctrs, quietly=TRUE, lib.loc=lib)
library(utf8, quietly=TRUE, lib.loc=lib)
library(glue, quietly=TRUE, lib.loc=lib)
library(fansi, quietly=TRUE, lib.loc=lib)
library(crayon, quietly=TRUE, lib.loc=lib)
library(cli, quietly=TRUE, lib.loc=lib)
library(magrittr, quietly=TRUE, lib.loc=lib)
library(pillar, quietly=TRUE, lib.loc=lib)
library(colorspace, quietly=TRUE, lib.loc=lib)
library(RColorBrewer, quietly=TRUE, lib.loc=lib)
library(R6, quietly=TRUE, lib.loc=lib)
library(labeling, quietly=TRUE, lib.loc=lib)
library(farver, quietly=TRUE, lib.loc=lib)
library(stringi, quietly=TRUE, lib.loc=lib)
#library(tidyselect, quietly=TRUE, lib.loc=lib)
library(tibble, quietly=TRUE, lib.loc=lib)
#library(generics, quietly=TRUE, lib.loc=lib)
library(withr, quietly=TRUE, lib.loc=lib)
library(scales, quietly=TRUE, lib.loc=lib)
library(isoband, quietly=TRUE, lib.loc=lib)
library(digest, quietly=TRUE, lib.loc=lib)
library(dplyr, quietly=TRUE, lib.loc=lib)
library(ggplot2, quietly=TRUE, lib.loc=lib)
library(pafr, quietly=TRUE, lib.loc=lib)

#Arguments (sous forme de liste)
args <- commandArgs(TRUE)
print("Traitement de :")
print(args[1])
print("Issue de l'alignement de :")
print(paste(args[2],"et",args[3]))

#Plot
ali<-read_paf(args[1])
plot<-dotplot(
      ali,
      order_by = "qstart",
      label_seqs = TRUE,
      dashes = TRUE,
      ordering = list(),
      alignment_colour = "blue",
      ylab=args[2],
      xlab=args[3],
      line_size = 1
)+theme_bw()+labs(title=paste("plot",args[2],args[3],sep="_"))
name<-paste("plot_",args[2],"_",args[3],".pdf",sep="")
ggsave(name , plot =plot , width=50,height=50,limitsize=FALSE, units="cm", device="pdf")
