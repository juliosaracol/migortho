## Universidade Federal de Pelotas
## Programa de Pos-Graduacao em Computacao - PPGC
## Julio Saracol 

## avaliacao mockturtle scripts EPFL
import sys
import random;
import string;
import os.path; # para verificar se existe o arquivo
import csv; 	# para trabalhar com arquivos do tipo csv/xls
import glob; 	#para procurar arquivos com expressoes iguais ao shell

########################################################################
#-----------------Leitura do Arquivo xls das colunas que interessam-----
def getInformationFile(Archive, methodName, flagNames):
	newColumns = []; #coluna na xls de saida referente a 1 metodo
	with open(Archive) as csvfile:
		spamreader = csv.reader(csvfile, delimiter=';') #leitura da xls circuito por circuito
		flagHeader=True;
		for row in spamreader: #leitura de uma linha
			if(flagHeader != True):
				if(flagNames == True):
					#print "flagname true";
					nameCircuit = str(row[0]).replace(str(fileIn),"");
					nameCircuit = nameCircuit.replace(str(methodName)+"/log_","");
					nameCircuit = nameCircuit.replace("_.txt","");
					infoCircuit = nameCircuit+";"+str(row[3])+";"+str(row[4])+";"+str(row[7])+";"+str(row[8])+";"+str(row[9])+";"+str(row[10])+";"
				else:
					infoCircuit = str(row[7])+";"+str(row[8])+";"+str(row[9])+";"+str(row[10])+";"
				newColumns.append(infoCircuit);
			else:#retira o cabecalho do arquivo geral pois sera criado em funcao do nome do metodo
				flagHeader=False;
			#print len(row)
			#print(', '.join(row))
			#print "circuit: "+str(row[0]);
			#print "gates: "+str(row[3]);
			#print "level: "+str(row[4]);
			#print "gates: "+str(row[7]);
			#print "level: "+str(row[8]);
			#print "%gates: "+str(row[9]);
			#print "%level: "+str(row[10]);
		#print newColumns;
		return newColumns;
#-----------------------------------------------------------------------
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
		arquivoResultGeral.close();
##-------carrega os parametros definidos--------------------------------
parameters = [];
for param in sys.argv :
	parameters.append(param);
if len(parameters) == 3:
	fileIn 	= parameters[1]; 	#---nome da pasta de entrada
	fileOut = parameters[2];	#---nome da arquivo de saida
else:
	print "DIGITED "+str(len(parameters))+" PARAMETERS, BUT NEEDS 2";
	print "ERROR in parameters: python evaluationGates.py folderIn fileOut.xls";
	exit();
##----------------------------------------------------------------------
newLines=[];
methodsName=[];
flag=True;
for file in glob.glob(str(fileIn)+"*.xls"):
	print "arquivo sendo contabilizado: "+str(file);
	#identifica o nome do metodo/script (pelo nome da pasta)
	method = file.replace(fileIn,"");
	method = method.replace(".xls","");
	methodsName.append(method);
	newLines.append(getInformationFile(file, method, flag));
	flag=False;
linhas=len(newLines);
colunas=len(newLines[0]);
#cabecalho da tabela com os nomes identificados acima
stringOut="";
stringOut+="Circuito;Original-Gates;Original-Level;"
for name in methodsName:
	stringOut+=name+"-Gates;"+name+"-Level;"+name+"-%Gates;"+name+"-%Level;"		
stringOut+="\n";
#preenche com as informacoes de cada metodo
for i in range(colunas):
#	print "novo metodo: "
	for j in range(linhas):
#		print newLines[j][i];
#		print "j="+str(j)+" i="+str(i);
		stringOut+=str(newLines[j][i]);
	stringOut+="\n";
resultAllXls(stringOut,fileOut);		
	
			

