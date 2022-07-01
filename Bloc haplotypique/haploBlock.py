import csv 
import operator
import sys

i=0 #compteur des deux première lignes
cptBloc=1 
individuH1=5 # position des colonnes d'hap des individus dans les lignes du fichier d'entré
individuH2=6

for cptInd in range(1,12): # 12 passages pour les 12 individus
    csvfile = open(sys.argv[1], 'r')# ouverture du fichier csv
    reader = csv.reader(csvfile)
    for row in reader:
        if(i==0): # lecture du header
            fileOut=row[individuH1][:-3]+".out" # nom du fichier de sorti 
            out = open(fileOut,'w') # ouverture du fichier de sorti
            print(row[individuH1][:-3])
            out.write("numBloc markerStart cM markerStop cM LG contig hap1 hap2\n") # écriture du header
            i=i+1 # indication qu'on a passé la première ligne
        else: #on a lu le header
            if (i==1): # lecture deuxième ligne (première ligne de données)
                contig = {} # création du dico pour compter les apparatitions de contigs (dans le bloc)
                contigLG = {} # création du dico pour compter les apparatitions de contigs (dans le groupe de liaison)
                contig[row[3]]=contig.get(row[3],0)+1 #maj du compteur d'apparition des contigs
                contigLG[row[3]]=contigLG.get(row[3],0)+1 #maj du compteur d'apparition des contigs
                hap1=row[individuH1] # lecure de l'haplotype 1
                hap2=row[individuH2] # lecure de l'haplotype 2
                markerStart = row[0] # mémorise le premier marker du bloc
                cMstart = row[2] #mémorise la distance génétique du premier marker
                LG=row[1] # mémorise le bloc de liaison
                i=i+1 # indication qu'on commence à lire la suite des données
            else: # ligne 3 et + du fichier
                if(row[individuH1]!=hap1 or row[individuH2]!=hap2 or LG!=row[1]): # on observe un changement d'hap ou de LG
                    max_contig= max(contig.items(), key=operator.itemgetter(1))[0] #on prend le max du dico
                    #affichage des données 
                    out.write(str(cptBloc)+" "+markerStart+" "+str(cMstart)+" "+markerStop+" "+str(cMstop)+" "+LG+" "+max_contig+" "+hap1+" "+hap2+"\n")
                    if(row[1]!=LG): #si on a changé de bloc de liaison
                        print(str(cptBloc))
                        #out.write("eff contig dans LG : "+str(LG)+" "+str(contigLG)+"\n") # affichage du compteur des contigs dans le LG
                        contigLG={} # on remet le compteur à zéro
                        LG=row[1] # maj du LG
                        cptBloc=0
                    cptBloc+=1 
                    contig = {} #mise à zéro du dico de contig
                    contig[row[3]]=contig.get(row[3],0)+1 #maj du dico 
                    contigLG[row[3]]=contigLG.get(row[3],0)+1  #maj du dico
                    hap1=row[individuH1] # nouveau hap
                    hap2=row[individuH2]
                    markerStart = row[0] # nouveau marker start
                    cMstart = row[2] 
                    
                else: #on continue la lecture d'un bloc
                    contig[row[3]]=contig.get(row[3],0)+1 # maj du dico 
                    contigLG[row[3]]=contigLG.get(row[3],0)+1 # maj du dico 
                    hap1=row[individuH1] #maj des hap
                    hap2=row[individuH2]
                    markerStop = row[0] # mémorisation des marker pour affichage du dernier
                    cMstop = row[2]
    # dernière ligne du fichier
    max_contig= max(contig.items(), key=operator.itemgetter(1))[0] #calcul du max
    out.write(str(cptBloc)+" "+markerStart+" "+str(cMstart)+" "+markerStop+" "+str(cMstop)+" "+LG+" "+max_contig+" "+hap1+" "+hap2+"\n")#maj du dernier bloc du csv
    print(str(cptBloc))
    #out.write("eff contig dans LG : "+str(LG)+" "+str(contigLG)+"\n")
    individuH1+=2 # on passe à l'individu suivant
    individuH2+=2 # on passe à l'individu suivant
    i=0 # cpt pour relire le header 
    cptBloc=1 
# fermeture des flux
csvfile.close()
out.close()


        