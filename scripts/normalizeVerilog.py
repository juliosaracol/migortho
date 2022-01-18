## Universidade Federal de Pelotas
## Programa de Pos-Graduacao em Computacao - PPGC
## Julio Saracol 

## normalizacao dos arquivos Verilog permitidos pelo parser EPFL
import sys
import random;
import string;

########################################################################
#------------- escreve no arquivo de saida-------------------------------
def escreveArquivo(string,fileOut):
	fileOut = open(fileOut,'w');
	print str(fileOut)+"\n\n";
	fileOut.write(string);
	fileOut.close();
########################################################################

def identify_majority(tokenRight):
	if(len(tokenRight) == 2):
		tokenDefinition = [];
		tokenDefinition = string.split(token[1],' ');   # quebra a string em uma lista
		if(len(tokenDefinition) == 12):
			print tokenDefinition[4]+"\n";
			print tokenDefinition[8]+"\n";
			if(tokenDefinition[4] == "|" and tokenDefinition[8] == "|"):				
				print "ANTERIOR"+str(tokenDefinition)+"\n";
				if(tokenDefinition[2] == "&" and tokenDefinition[6] == "&" and tokenDefinition[10] == "&"):
					op1 = tokenDefinition[1].replace("(","");
					op2 = tokenDefinition[3].replace(")","");
					op3 = tokenDefinition[5].replace("(","");
					op4 = tokenDefinition[7].replace(")","");
					op5 = tokenDefinition[9].replace("(","");
					op6 = tokenDefinition[11].replace(");\n","");
					print op1+" "+op2+" "+op3+" "+op4+" "+op5+" "+op6+"\n";
					if(op1!=op3)or(op2!=op5)or(op4!=op6):
						print "not ok";
	return 1;
def modify_majority(tokenRight):
	#print tokenRight;
	return tokenRight;



########################################################################
########################CARREGA ARQUIVO VERILOG ########################
########################################################################
##-------carrega os parametros definidos--------------------------------
parameters = [];
for param in sys.argv :
	parameters.append(param);
if len(parameters) == 3:
	fileIn 	= parameters[1]; 	#---nome do arquivo de entrada da TV
	fileOut = parameters[2];#----nome da funcao
else:
	print "DIGITED "+str(len(parameters))+"PARAMETERS, BUT NEEDS 3";
	print "ERROR in parameters: python nomalizeVerilog.py fileInVerilog.v fileOutVerilog.v";
	exit();
##----------------------------------------------------------------------



#---------MAIN----------------------------------
content = open(fileIn,"r");
listLines = [];
#-------parseia o arquivo de entrada------------
while True:
		number = content.readline();
		if len(number) > 0:
			token = [];
			token = string.split(number,'=');   # quebra a string em uma lista
#			print token;
			if((len(token)==2) and (identify_majority(token) == 1)):
				newToken = modify_majority(token);
			else:
				listLines.append(token);
		else:
			break;
#-------------------------------------------------------------

