#Julio Saraçol
#Universidade Federal de Pelotas-UFPel
#Universidade Federal do Pampa -Unipampa
#GACI
#Fiction Tool 2.1.1 - Added Migortho Flow
# script para rodar comandos no Fiction

function help(){
	echo "-----------------HELP---------------------------------"
	echo "./runCmd.sh parametros Fiction:[pastaEntrada nomeSaidaLog comandos(separados por ;) pastaSaida[Opcional]"
	echo "OBS: No arquivo run.sh são definidos os parâmetros acima;"
	echo "-------------------------------------------------------"
}

function warning(){
		echo "------!!!!!!!!!!!!!!ERRO NAS CONFIGURAÇÕES DO SCRIPT!!!!!!!!!!!!!--------"
    	echo "./runCmd.sh parametros Fiction:[pastaEntrada nomeSaidaLog comandos(separados por ;) pastaSaida[Opcional]"
		echo "OBS: No arquivo run.sh são definidos os parâmetros acima;"
}

if [ $# -gt 1 ] & [ "$1" = "help" >/dev/null ];
then
    help
	exit 1
fi

if [ $# -gt 1 ];
then
   #------------------------------------------------------------------------------
   #------------------------------------------------------------------------------
   #------------------------------------------------------------------------------
   #----------------------------GERADOR DE ARQUIVOS OTIMIZADOS--------------------
   if [ $# -eq 4 ];
   then
		echo "*******RODANDO COM PARAMETROS O SCRIPT**********************"
		pastaEntrada=$1		#pastaBase para a busca dos arquivos dos circuitos
		nomeBase=$2  		#nomeBase para os arquivos de saída
		comandos=$3  		#comandos a serem executados
		pastaSaida=$4		#pastaBase para a saída
		echo "-------------------------------------"
		#--------------------Execução no Fiction2.0 Display de Informações----------------------
		echo "ESCRIPT DE EXECUÇÃO FICTION 2.1.1:"
		echo "Caminho de Fonte:" $pastaEntrada
		echo "Nome Base: "$nomeBase
		echo "comandos: "$comandos
		echo "Caminho de Saída: "$pastaSaida
		echo "-------------------------------------"
		#---------------------------Arquivos de Entrada-------------------------
		for filepath in $pastaEntrada*.v ; do
			f="${filepath##*/}"
			echo "####Rodando Fiction CMD para o circuito:" $f
            date +"#Date start:"%d/%m/%Y/%H:%M:%S:%N >> "$pastaSaida${f%.*}$nomeBase.txt"
    		\time -a -o "$pastaSaida${f%.*}$nomeBase.txt" -f "#Program: %C;\n#Total time (time used by the process): %E;\n#User Mode (time used by the process in s) %U;\n#CPU: %P;"	.././fiction -c "read_verilog -m $filepath; ps -m; $comandos; ps -m; write_verilog -m $pastaSaida${f%.*}$nomeBase.v;" >> "$pastaSaida${f%.*}$nomeBase.txt"
            date +"#Date final:"%d/%m/%Y/%H:%M:%S:%N >> "$pastaSaida${f%.*}$nomeBase.txt"
#			.././fiction -c "read $filepath; ps -w; $comandos; ps -g; cell; ps -c; qca $pastaSaida${f%.*}$nomeBase.qca" -l "$pastaSaida"${f%.*}"$nomeBase".json >> "$pastaSaida${f%.*}$nomeBase.txt"
		done
		echo "-------------------------------------"
	else
		#-----caso os parametros não estejam exatamente como precisam ser especificados
        warning
		exit
	fi
else
		#-----caso os parametros não estejam exatamente como precisam ser especificados
        warning
		exit
fi

