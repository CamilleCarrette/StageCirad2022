#dependencies
#devtools::install_github("dwinter/pafr", lib="/home/carrettec/scratch/aln/lib")

lib <- "/home/carrettec/scratch/aln/lib"
library(farver,lib.loc=lib)
library(ellipsis,lib.loc=lib)
library(vctrs,lib.loc=lib)
library(gridExtra,lib.loc=lib)
library(rlang,lib.loc=lib)
library(utf8,lib.loc=lib)
library(fansi,lib.loc=lib)
library(crayon,lib.loc=lib)
library(cli,lib.loc=lib)
library(magrittr,lib.loc=lib)
library(pillar,lib.loc=lib)
library(colorspace,lib.loc=lib)
library(RColorBrewer,lib.loc=lib)
library(R6,lib.loc=lib)
library(labeling,lib.loc=lib)

library(stringi,lib.loc=lib)
library(tidyselect,lib.loc=lib)
library(tibble,lib.loc=lib)
library(generics,lib.loc=lib)
library(withr,lib.loc=lib)
library(scales,lib.loc=lib)
library(isoband,lib.loc=lib)
library(digest,lib.loc=lib)
library(dplyr,lib.loc=lib)
library(ggplot2,lib.loc=lib)
library(pafr,lib.loc=lib)

args <- commandArgs(TRUE)

N <- read.table(args[1],header=TRUE)
NHist <- ggplot(N, aes(x=posFin,y=nbrN))+
  geom_col(colour="black")+scale_x_continuous("pos",labels = Mb_lab)+
  scale_y_continuous("Nombre de N")

  name<-paste("Nhist_",args[2],".pdf",sep="")
  ggsave(name , plot =NHist)
