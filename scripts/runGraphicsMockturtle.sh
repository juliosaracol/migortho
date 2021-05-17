#Julio Saraçol
#Universidade Federal de Pelotas-UFPel
#GACI
#Julio Saraçol
#Universidade Federal de Pelotas-UFPel
#Universidade Federal do Pampa -Unipampa
#GACI
#Fiction Tool 2.1.1 - Added Migortho Flow
#-----Script para gerar graficos de avaliação geral sobre as soluções do mockturtle

function help(){
   echo "---------PARA RODAR NECESSARIO 1 XLS DE CUSTOS ou PASTA e PARAMETROS----------------"
   echo "# parametro1:nome_do_aquivo.xls Nome.png e tipo de plotagem, o script de saída será gnuplot.plt"
   echo "----------------------ARQUIVO------------------------------------------------------------"
   echo "./runGraphicsMockturtle.sh nome_do_arquivo.xls comparacao.png tipo_de_comparação (points|lines|linespoints|histogram|filledcu) tamanho_da_linha "
}


if [ $# -lt 4 ];
then
   help
   exit 1
fi
#--------------------------------------------------------------
rm gnuplot.plt
arq1=$1 					#nome do arquivo(pasta) a ser carregado
#--------------------------------------------------------------
if [ $# -eq 4 ] & echo "$arq1" | egrep ".xls" >/dev/null #identifica se o parametro eh um unico xls
then
	saida=$2					#nome do arquivo de saída
	plot=$3
	border=$4
	echo "Criando gnuplot $arq1"
	echo "set key below;" >> gnuplot.plt
#	echo "set key off ;" >> gnuplot.plt
	echo "set grid ;" >> gnuplot.plt
	echo "set boxwidth 1 ;" >> gnuplot.plt
	echo "set style fill solid 0.5 ;" >> gnuplot.plt
	echo "set datafile sep ';'" >> gnuplot.plt
	echo "set term png ;" >> gnuplot.plt
	echo "set title 'Avalição Scripts Mockturtle';" >> gnuplot.plt
	echo "set output '"$saida"' ;" >> gnuplot.plt
	echo "set ylabel 'Gates'; set xlabel 'Scripts'; set noxtics;" >> gnuplot.plt
#	echo "set style boxplot nooutliers ;" >> gnuplot.plt
     comando="'"$arq1"' using (2):  2 with "$plot"   lw "$border" title 'Original' , ";
	comando+="'"$arq1"' using (4):  4 with "$plot"   lw "$border" title '2migRefac' , ";
	comando+="'"$arq1"' using (8):  8 with "$plot"   lw "$border" title '3migAlg' , ";
	comando+="'"$arq1"' using (12): 12 with "$plot"  lw "$border" title 'mix2k5' , ";
    comando+="'"$arq1"' using (16): 16 with "$plot"  lw "$border" title 'mix2k3' , ";
	comando+="'"$arq1"' using (20): 20 with "$plot"  lw "$border" title '3migCutRewritek4' , ";
	comando+="'"$arq1"' using (24): 24 with "$plot"  lw "$border" title '3migCutRewritek3' , ";
	comando+="'"$arq1"' using (28): 28 with "$plot"  lw "$border" title 'mix1k3' , ";
	comando+="'"$arq1"' using (32): 32 with "$plot"  lw "$border" title '2migCutRewritek4' , ";
	comando+="'"$arq1"' using (36): 36 with "$plot"  lw "$border" title 'mix4k5' , ";
	comando+="'"$arq1"' using (40): 40 with "$plot"  lw "$border" title '3migRefac' , ";
	comando+="'"$arq1"' using (44): 44 with "$plot"  lw "$border" title 'mix3k5' , ";
	comando+="'"$arq1"' using (48): 48 with "$plot"  lw "$border" title '2migAlg' , ";
	comando+="'"$arq1"' using (52): 52 with "$plot"  lw "$border" title 'migRefac' , ";
	comando+="'"$arq1"' using (56): 56 with "$plot"  lw "$border" title 'mix4k3' , ";
	comando+="'"$arq1"' using (60): 60 with "$plot"  lw "$border" title 'mix1k4' , ";
	comando+="'"$arq1"' using (64): 64 with "$plot"  lw "$border" title 'migAlg' , ";
	comando+="'"$arq1"' using (68): 68 with "$plot"  lw "$border" title 'mix3k4' , ";
	comando+="'"$arq1"' using (72): 72 with "$plot"  lw "$border" title 'mix4k4' , ";
	comando+="'"$arq1"' using (76): 76 with "$plot"  lw "$border" title 'mix2k4' , ";
	comando+="'"$arq1"' using (80): 80 with "$plot"  lw "$border" title '2migCutRewritek3' , ";
	comando+="'"$arq1"' using (84): 84 with "$plot"  lw "$border" title 'mix1k5' , ";
	comando+="'"$arq1"' using (88): 88 with "$plot"  lw "$border" title '3migResub' , ";
	comando+="'"$arq1"' using (92): 92 with "$plot"  lw "$border" title 'migCutrewritek4' , ";
	comando+="'"$arq1"' using (96): 96 with "$plot"  lw "$border" title 'mix3k3' , ";
	comando+="'"$arq1"' using (100):100 with "$plot" lw "$border" title 'migResub' , ";
	comando+="'"$arq1"' using (104):104 with "$plot" lw "$border" title 'migCutRewritek3' , ";
	comando+="'"$arq1"' using (108):108 with "$plot" lw "$border" title '2migResub'";
	echo "plot "$comando" " >> gnuplot.plt
	echo "------CRIANDO GRÁFICOS GNUPLOT-------"
	gnuplot < gnuplot.plt
	echo "*******SCRIPT EXECUTADO COM SUCESSO*******"
else
    help
    exit 1
fi


