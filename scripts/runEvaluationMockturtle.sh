#Julio Saraçol
#Universidade Federal de Pelotas-UFPel
#Universidade Federal do Pampa -Unipampa
#GACI
#Fiction Tool 2.1.1 - Added Migortho Flow
#---Script que dispara o script em python para a avaliação dos métodos Mockturtle .

function help(){
	echo "-----------------HELP---------------------------------"
	echo "./runEvaluationMockturtle.sh parametros:[pastaEntrada nomeSaida.xls padrão_de_nome_pastaEntrada(opcional)]"
	echo "-------------------------------------------------------"
    echo "Será criado uma xls com a contagem de i/o, gates, level de cada circuito"
    echo "-----------------------------------------------------------------------------------"
}


if [ $# -gt 1 ] & [ "$1" = "help" >/dev/null ];
then
    help
	exit 1
fi

if [ $# -lt 2 ];
then
    help
    exit 1
fi

#--------------------------------------------------------------
pasta=$1    	#nome da pasta a ser carregada
SAIDA=$2 		#nome do arquivo de saída
if [ $# -eq 3 ];
then
 padrao=$3
 pasta=$pasta"*"$padrao
fi
#--------------------------------------------------------------
FILES=$pasta"*.txt"
for f in $FILES
do
	echo "Avaliando Resultados $f"
	python evaluationGates.py $f $SAIDA
done

