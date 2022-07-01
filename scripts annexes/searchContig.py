import operator
import sys
import csv

#usage python3 searchContig.py fileIn.paf fileOut.paf Chr borneInf borneSup
#le script donne un paf qui filtre les donnés de fileIn avec les alignements de Chr aux pos borneInf et borneSup

file = open(sys.argv[1], 'r')
reader = csv.reader(file,delimiter='\t')
fileout = open(sys.argv[2],"w")
writer = csv.writer(fileout, delimiter="\t", lineterminator="\n")
for row in reader:
    if(str(row[0]) == sys.argv[3] and int(row[2]) >= int(sys.argv[4]) and int(row[2]) <= int(sys.argv[5])):
        writer.writerow(row)
       