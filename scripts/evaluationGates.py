## Universidade Federal de Pelotas
## Programa de Pos-Graduacao em Computacao - PPGC
## Julio Saracol 

## avaliacao mockturtle scripts EPFL
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
		arquivoResultGeral = open(fileOut,'w');
		arquivoResultGeral.write('Circuito;'+'INPUTS;'+'OUTPUTS;'+'GATES;'+'LEVEL;'+'INPUTS;'+'OUTPUTS;'+'GATES;'+'LEVEL;'+'%GATES;'+'%LEVEL;\n');
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
	print "ERROR in parameters: python evaluationGates.py fileIn.txt fileOut.xls";
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
			if(token[0] == "MIG"):
				listLines.append(token)
		else:
			break;
##----------------------------------------------------------------------
#print listLines[0]
inOut = string.split(listLines[0][5],'/');
stringFile+=inOut[0]+";";#inputs
stringFile+=inOut[1]+";";#outputs	
stringFile+=str(listLines[0][10])+";";#gates
stringFile+=str(listLines[0][15].replace("\n",";"));#level\n
##----------------------------------------------------------------------
#print listLines[1]
inOut = string.split(listLines[1][5],'/');
stringFile+=inOut[0]+";";#inputs
stringFile+=inOut[1]+";";#outputs	
stringFile+=str(listLines[1][10])+";";#gates
stringFile+=str(listLines[1][15].replace("\n",";"));#level\n
#-------------------------------------------------------------
gatesPre=float(listLines[0][10]);
gatesPos=float(listLines[1][10]);
levelPre=float(listLines[0][15].replace("\n",""));
levelPos=float(listLines[1][15].replace("\n",""));
stringFile+=str(round(float(100-(gatesPos*100)/gatesPre),2))+";";
stringFile+=str(round(float(100-(levelPos*100)/levelPre),2))+";";
#-------------------------------------------------------------
resultAllXls(stringFile,fileOut);
#-------------------------------------------------------------
