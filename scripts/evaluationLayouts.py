## Universidade Federal de Pelotas
## Programa de Pos-Graduacao em Computacao - PPGC
## Julio Saracol

## avaliacao Fiction logs metodo Migortho
import sys
import random;
import string;
import os.path ## para verificar se existe o arquivo
########################################################################
#------------------grava os resultadosGerais em um arquivo xls--------------------
def resultAllXls(stringFile,fileOut):
	if fileOut != "":
		#trata a criacao do arquivo
		if os.path.isfile(fileOut) == False:
			resultAllXlsFinal(fileOut);
		arquivoResultGeral = open(fileOut,'a');
		arquivoResultGeral.write(stringFile+'\n');
		arquivoResultGeral.close();
def resultAllXlsFinal(fileOut):
	if fileOut != "":
		arquivoResultGeral = open(fileOut,'w');#G: 15, #W: 40, #C: 3, #L: 0, CP: 16, TP: 1/2
		arquivoResultGeral.write('Circuito;'+'INPUTS;'+'OUTPUTS;'+'VERTEX;'+'BLOCKS-TILES;'+'GATES;'+'WIRE;'+'CROSSING;'+'LATCHES;'+'CRITICALPATH;'+'THROUGHPUT;'+'CELLSGRID;'+'CELLS;'+'DIMENSION-TILES\n');
		arquivoResultGeral.close();
########################################################################
########################CARREGA ARQUIVO LOG.TXT ########################
########################################################################
##-------carrega os parametros definidos--------------------------------
parameters = [];
for param in sys.argv :
	parameters.append(param);
if len(parameters) == 3:
	fileIn 	= parameters[1]; 	#---nome do arquivo de entrada
	fileOut = parameters[2];	#---nome da arquivo de saida
else:
	print "DIGITED "+str(len(parameters))+" PARAMETERS, BUT NEEDS 2";
	print "ERROR in parameters: python evaluationLayouts.py fileIn.txt fileOut.xls";
	exit();
##----------------------------------------------------------------------


#---------------------------------MAIN----------------------------------
content = open(fileIn,"r");
listLines = [];
stringFile="";
stringFile+=fileIn+";";
#-------parseia o arquivo de entrada------------
while True:
		line = content.readline();
		if len(line) > 0:
			token = [];
			token = string.split(line," ");   # quebra a string em uma lista
			if((str(token[0]).find("#")) == -1): # filtro para nao considerar comentarios no log, tempo de execucao e etc..
				listLines.append(token);
		else:
			break;
#print listLines;
#------------------------------------------------
#print "listLines e:";
#print listLines[0];
inOut = string.split(listLines[0][3],'/');
stringFile+=inOut[0]+";";#inputs
stringFile+=inOut[1].replace(",","")+";";#outputs
stringFile+=str(listLines[0][5].replace("\n",";"))
#------------------------------------------------
#print listLines[1];
stringFile+=str(listLines[1][2])+" x "+str(listLines[1][4]).replace(",","")+";"
stringFile+=str(listLines[1][6]).replace(",","")+";"
stringFile+=str(listLines[1][8]).replace(",","")+";"
stringFile+=str(listLines[1][10]).replace(",","")+";"
stringFile+=str(listLines[1][12]).replace(",","")+";"
stringFile+=str(listLines[1][14]).replace(",","")+";"
stringFile+=str(str(listLines[1][16].replace("\n",";")).replace("/"," / "));
#------------------------------------------------
#print len(listLines);
#print listLines[2];
if(len(listLines) > 2):
	stringFile+=str(listLines[2][3])+" x "+str(listLines[2][5]).replace(",","")+";"
	stringFile+=str(listLines[2][7].replace("\n",";"))
else:
	stringFile+=" 0 x 0 ;"
	stringFile+= str(0)+str(";")
dimensionX= int(listLines[1][2])
dimensionY=int(listLines[1][4].replace(",",""))
stringFile+=str(dimensionX*dimensionY)
#------------------------------------------------
#print stringFile
resultAllXls(stringFile,fileOut);

#-------------------------------------------------------------
