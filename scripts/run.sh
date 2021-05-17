#!/bin/bash
#Julio Saraçol
#Universidade Federal de Pelotas-UFPel
#Universidade Federal do Pampa -Unipampa
#GACI
#Fiction Tool 2.1.1 - Added Migortho Flow
#Script para execução diversas na Fiction 2.1.1 o qual invoca
#o script ./runMockturtle.sh ou runMigortho.sh passando os parametros necessários

function help(){
    echo "-----------------HELP---------------------------------\n"
	echo "./run.sh parametros Script 4 modos de execução:\n"
	echo "  1# Mockturtle: [mockturtle pastaEntrada pastaSaída]\n"
	echo "  2# EvaluationMockturtle: [evalmockturtle pastaEntrada]\n"
	echo "  3# GraphicsEvaluationMockturtle: [plotevalmockturtle arquivo.xls plot[boxplot|lines|linespoint|point|boxes]]\n"
	echo "  4# Migortho: [migortho pastaEntrada pastaSaída]\n"
	echo "  5# EvaluationMigortho: [evalmigortho pastaEntrada]\n"
	echo "  6# Cmd: [cmd pastaEntrada pastaSaída]\n"
	echo "  7# EvaluationCmd: [evalcmd pastaEntrada]\n"
	echo "OBS: No arquivo run.sh são definidos os parâmetros acima;\n"
	echo "-------------------------------------------------------"
}


if [ $# -gt 1 ] & [ "$1" = "help" >/dev/null ];
then
    help
	exit 1
fi


####################################MOCKTURTULE | MIGORTHO | CMD  #############################################
####################################MOCKTURTULE | MIGORTHO | CMD  #############################################
####################################MOCKTURTULE | MIGORTHO | CMD  #############################################
####################################MOCKTURTULE | MIGORTHO | CMD  #############################################
####################################MOCKTURTULE | MIGORTHO | CMD  #############################################
####################################MOCKTURTULE | MIGORTHO | CMD  #############################################
####################################MOCKTURTULE | MIGORTHO | CMD  #############################################


if [ $# -gt 2 ]
then
entrada=$2;
saidaBase=$3;


#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------

if [ "$1" = "cmd" >/dev/null ]
then
#Possíveis comandos FICTION-MIG:
#fiction> mig
#migAlg   migCutRewrite(-k)  migNode(-k kmax<=4)        migResub        migRefac

nomeBase="migCutRewriteK3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
#migCutRewrite somente para transformar em mig utilizando majoritária
./runCmd.sh "$entrada" "$nomeBase" "migCutRewrite -k 3" "$saida"
fi

#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
if [ "$1" = "migortho" >/dev/null ]
then
./runMigortho.sh $entrada Migortho "migortho " $saidaBase
fi

#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
if [ "$1" = "plotevalmockturtle" >/dev/null ]
then
grafico=$3
pngSaida=${entrada:0:lenght-3}"png"
./runGraphicsMockturtle.sh "$entrada" "$pngSaida" "$grafico" "2"
fi

#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
if [ "$1" = "mockturtle" >/dev/null ]
then
#Possíveis comandos FICTION-MIG:
#fiction> mig
#migAlg   migCutRewrite(-k)  migNode(-k kmax<=4)        migResub        migRefac

nomeBase="migCutRewriteK3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 3" "$saida"

nomeBase="migCutRewriteK4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 4" "$saida"

nomeBase="migCutRewriteK5";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 5" "$saida"

nomeBase="migCutRewriteK6";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 6" "$saida"

nomeBase="migCutRewriteK7";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 7" "$saida"

nomeBase="migCutRewriteK8";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 8" "$saida"

#nomeBase="migCutRewriteK9";
#saida=$saidaBase$nomeBase"/"
#mkdir $saida
#rm $saida*.txt
#./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 9" "$saida"

nomeBase="migNodeK3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migNode -k 3" "$saida"

nomeBase="migNodeK4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migNode -k 4" "$saida"


nomeBase="migAlg";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migAlg" "$saida"


nomeBase="migResub";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migResub" "$saida"


nomeBase="migRefac";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac" "$saida"


nomeBase="2migCutRewriteK3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 3;migCutRewrite -k 3" "$saida"


nomeBase="2migCutRewriteK4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 4;migCutRewrite -k 4" "$saida"

nomeBase="2migCutRewriteK5";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 5;migCutRewrite -k 5" "$saida"


nomeBase="2migCutRewriteK6";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 6;migCutRewrite -k 6" "$saida"

nomeBase="2migCutRewriteK7";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 7;migCutRewrite -k 7" "$saida"

nomeBase="2migCutRewriteK8";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 8;migCutRewrite -k 8" "$saida"

#nomeBase="2migCutRewriteK9";
#saida=$saidaBase$nomeBase"/"
#mkdir $saida
#rm $saida*.txt
#./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 9;migCutRewrite -k 9" "$saida"


nomeBase="2migNodeK3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migNode -k 3;migNode -k 3" "$saida"

nomeBase="2migNodeK4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migNode -k 4;migNode -k 4" "$saida"

nomeBase="2migAlg";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migAlg; migAlg" "$saida"


nomeBase="2migResub";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migResub; migResub" "$saida"


nomeBase="2migRefac";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migRefac" "$saida"


nomeBase="3migCutRewriteK3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 3; migCutRewrite -k 3;migCutRewrite -k 3" "$saida"


nomeBase="3migCutRewriteK4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 4; migCutRewrite -k 4;migCutRewrite -k 4" "$saida"

nomeBase="3migCutRewriteK5";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 5; migCutRewrite -k 5;migCutRewrite -k 5" "$saida"


nomeBase="3migCutRewriteK6";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 6; migCutRewrite -k 6;migCutRewrite -k 6" "$saida"

nomeBase="3migCutRewriteK7";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 7; migCutRewrite -k 7;migCutRewrite -k 7" "$saida"

nomeBase="3migCutRewriteK8";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 8; migCutRewrite -k 8;migCutRewrite -k 8" "$saida"

#nomeBase="3migCutRewriteK9";
#saida=$saidaBase$nomeBase"/"
#mkdir $saida
#rm $saida*.txt
#./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 9; migCutRewrite -k 9;migCutRewrite -k 9" "$saida"

nomeBase="3migNodeK3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migNode -k 3; migNode -k 3;migNode -k 3" "$saida"

nomeBase="3migNodeK4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migNode -k 4; migNode -k 4;migNode -k 4" "$saida"

nomeBase="3migAlg";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migAlg; migAlg; migAlg" "$saida"


nomeBase="3migResub";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migResub; migResub; migResub" "$saida"


nomeBase="3migRefac";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migRefac; migRefac" "$saida"

--
nomeBase="4migCutRewriteK3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 3; migCutRewrite -k 3; migCutRewrite -k 3; migCutRewrite -k 3" "$saida"


nomeBase="4migCutRewriteK4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 4; migCutRewrite -k 4; migCutRewrite -k 4; migCutRewrite -k 4" "$saida"

nomeBase="4migCutRewriteK5";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 5; migCutRewrite -k 5; migCutRewrite -k 5; migCutRewrite -k 5" "$saida"


nomeBase="4migCutRewriteK6";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 6; migCutRewrite -k 6; migCutRewrite -k 6; migCutRewrite -k 6" "$saida"

nomeBase="4migCutRewriteK7";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 7; migCutRewrite -k 7; migCutRewrite -k 7; migCutRewrite -k 7" "$saida"

nomeBase="4migCutRewriteK8";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 8; migCutRewrite -k 8; migCutRewrite -k 8; migCutRewrite -k 8" "$saida"

#nomeBase="4migCutRewriteK9";
#saida=$saidaBase$nomeBase"/"
#mkdir $saida
#rm $saida*.txt
#./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 9; migCutRewrite -k 9; migCutRewrite -k 9; migCutRewrite -k 9" "$saida"

nomeBase="4migNodeK3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migNode -k 3; migNode -k 3; migNode -k 3; migNode -k 3" "$saida"

nomeBase="4migNodeK4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migNode -k 4; migNode -k 4; migNode -k 4; migNode -k 4" "$saida"

nomeBase="4migAlg";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migAlg; migAlg; migAlg; migAlg" "$saida"


nomeBase="4migResub";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migResub; migResub; migResub; migResub" "$saida"


nomeBase="4migRefac";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migRefac; migRefac; migRefac" "$saida"

#---------------------------------------------MIX COMMANDS------------------------------------------


#mix1 migCutRewrite -k 3; migRefac; migResub; migResub;
nomeBase="mix1K3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 3; migRefac; migResub; migResub" "$saida"


nomeBase="mix1K4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 4; migRefac; migResub; migResub" "$saida"

nomeBase="mix1K5";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 5; migRefac; migResub; migResub" "$saida"

nomeBase="mix1K6";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 6; migRefac; migResub; migResub" "$saida"

nomeBase="mix1K7";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 7; migRefac; migResub; migResub" "$saida"

nomeBase="mix1K8";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 8; migRefac; migResub; migResub" "$saida"

#nomeBase="mix1K9";
#saida=$saidaBase$nomeBase"/"
#mkdir $saida
#rm $saida*.txt
#./runMockturtle.sh "$entrada" "$nomeBase" "migCutRewrite -k 9; migRefac; migResub; migResub" "$saida"

#mix2 migRefac; migCutRewrite -k 3; migResub; migResub;
nomeBase="mix2K3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migCutRewrite -k 3; migResub; migResub" "$saida"


nomeBase="mix2K4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migCutRewrite -k 4; migResub; migResub" "$saida"

nomeBase="mix2K5";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migCutRewrite -k 5; migResub; migResub" "$saida"

nomeBase="mix2K6";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migCutRewrite -k 6; migResub; migResub" "$saida"

nomeBase="mix2K7";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migCutRewrite -k 7; migResub; migResub" "$saida"

nomeBase="mix2K8";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migCutRewrite -k 8; migResub; migResub" "$saida"

#nomeBase="mix2K9";
#saida=$saidaBase$nomeBase"/"
#mkdir $saida
#rm $saida*.txt
#./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migCutRewrite -k 9; migResub; migResub" "$saida"

#mix3 migRefac; migResub; migResub; migCutRewrite -k 3;
nomeBase="mix3K3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migResub; migResub; migCutRewrite -k 3" "$saida"


nomeBase="mix3K4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migResub; migResub; migCutRewrite -k 4" "$saida"

nomeBase="mix3K5";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migResub; migResub; migCutRewrite -k 5" "$saida"

nomeBase="mix3K6";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migResub; migResub; migCutRewrite -k 6" "$saida"

nomeBase="mix3K7";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migResub; migResub; migCutRewrite -k 7" "$saida"

nomeBase="mix3K8";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migResub; migResub; migCutRewrite -k 8" "$saida"

#nomeBase="mix3K9";
#saida=$saidaBase$nomeBase"/"
#mkdir $saida
#rm $saida*.txt
#./runMockturtle.sh "$entrada" "$nomeBase" "migRefac; migResub; migResub; migCutRewrite -k 9" "$saida"

#mix4  migResub; migResub; migRefac; migCutRewrite -k 3;
nomeBase="mix4K3";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migResub; migResub; migRefac; migCutRewrite -k 3" "$saida"


nomeBase="mix4K4";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migResub; migResub; migRefac; migCutRewrite -k 4" "$saida"


nomeBase="mix4K5";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migResub; migResub; migRefac; migCutRewrite -k 5" "$saida"

nomeBase="mix4K6";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migResub; migResub; migRefac; migCutRewrite -k 6" "$saida"

nomeBase="mix4K7";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migResub; migResub; migRefac; migCutRewrite -k 7" "$saida"

nomeBase="mix4K8";
saida=$saidaBase$nomeBase"/"
mkdir $saida
rm $saida*.txt
./runMockturtle.sh "$entrada" "$nomeBase" "migResub; migResub; migRefac; migCutRewrite -k 8" "$saida"

#nomeBase="mix4K9";
#saida=$saidaBase$nomeBase"/"
#mkdir $saida
#rm $saida*.txt
#./runMockturtle.sh "$entrada" "$nomeBase" "migResub; migResub; migRefac; migCutRewrite -k 9" "$saida"

fi
#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
else
####################################EVALUATION#########################################################
####################################EVALUATION#########################################################
####################################EVALUATION#########################################################
####################################EVALUATION#########################################################
####################################EVALUATION#########################################################


if [ $# -gt 1 ]
then
entrada=$2;

#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
if [ "$1" = "evalmigortho" >/dev/null ]
then
xlsSaida=${entrada:0:lenght-1}"_MIGORTHO_EVALUATION_GENERAL.xls"
./runEvaluationOrtho.sh "$entrada" "$xlsSaida"
fi

#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
if [ "$1" = "evalcmd" >/dev/null ]
then
nomeBase="migCutRewriteK3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"
fi


#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
if [ "$1" = "evalmockturtle" >/dev/null ]
then

nomeBase="migCutRewriteK3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="migCutRewriteK4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="migCutRewriteK5";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="migCutRewriteK6";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="migCutRewriteK7";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="migCutRewriteK8";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#nomeBase="migCutRewriteK9";
#./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="migNodeK3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="migNodeK4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="migAlg";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="migResub";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="migRefac";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="2migCutRewriteK3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="2migCutRewriteK4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="2migCutRewriteK5";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="2migCutRewriteK6";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="2migCutRewriteK7";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="2migCutRewriteK8";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#nomeBase="2migCutRewriteK9";
#./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="2migNodeK3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="2migNodeK4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="2migAlg";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="2migResub";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="2migRefac";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="3migCutRewriteK3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="3migCutRewriteK4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="3migCutRewriteK5";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="3migCutRewriteK6";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="3migCutRewriteK7";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="3migCutRewriteK8";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#nomeBase="3migCutRewriteK9";
#./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="3migNodeK3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="3migNodeK4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="3migAlg";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="3migResub";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="3migRefac";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="4migCutRewriteK3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="4migCutRewriteK4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="4migCutRewriteK5";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="4migCutRewriteK6";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="4migCutRewriteK7";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="4migCutRewriteK8";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#nomeBase="4migCutRewriteK9";
#./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="4migNodeK3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="4migNodeK4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="4migAlg";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="4migResub";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="4migRefac";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#mix1 migCutRewrite -k 3; migRefac; migResub; migResub;
nomeBase="mix1K3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="mix1K4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix1K5";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix1K6";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix1K7";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix1K8";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#nomeBase="mix1K9";
#./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#mix2 migRefac; migCutRewrite -k 3; migResub; migResub;
nomeBase="mix2K3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix2K4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix2K5";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix2K6";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix2K7";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix2K8";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#nomeBase="mix2K9";
#./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#mix3 migRefac; migResub; migResub; migCutRewrite -k 3;
nomeBase="mix3K3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"


nomeBase="mix3K4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix3K5";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix3K6";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix3K7";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix3K8";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#nomeBase="mix3K9";
#./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#mix4  migResub; migResub; migRefac; migCutRewrite -k 3;
nomeBase="mix4K3";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix4K4";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix4K5";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix4K6";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix4K7";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

nomeBase="mix4K8";
./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

#nomeBase="mix4K9";
#./runEvaluationMockturtle.sh "$entrada$nomeBase/" "$entrada$nomeBase.xls"

xlsSaida=${entrada:0:lenght-1}"_EVALUATION_GENERAL.xls"
echo "------------Rodando script de avaliação geral na pasta $entrada $xlsSaida"
python evaluationGatesRelation.py "$entrada" "$xlsSaida"
echo "-------------------------------------------------------------"


fi
#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------
else
    help
	exit 1
fi
fi
