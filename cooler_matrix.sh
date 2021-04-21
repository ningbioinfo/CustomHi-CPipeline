#!/bin/bash

PAIR=$1
prefix=$(basename ${PAIR} .valid.pairs.gz)
COOLER_OUT=$2
CHR_SIZES=$3
BIN_SIZE=$4
MAXHIC_IN=$5
THREADS=$6
#SORT_PAIR=${COOLER_OUT}/${prefix}_pairs.sorted.txt.gz
BIN_FILE_PRE=${MAXHIC_IN}/${prefix}_${BIN_SIZE}.bin
BIN_FILE=${MAXHIC_IN}/${prefix}_${BIN_SIZE}.bed
mkdir -p ${COOLER_OUT}
mkdir -p ${MAXHIC_IN}

# transform format and index
#cooler csort -c1 2 -p1 3 -c2 4 -p2 5 --sep '\t' --out ${SORT_PAIR} ${PAIR} ${CHR_SIZES}

# make bins

cooler makebins ${CHR_SIZES} ${BIN_SIZE} --out ${BIN_FILE_PRE}

awk -F'\t' -v OFS='\t' '{ $(NF+1)=NR} 1' ${BIN_FILE_PRE} > ${BIN_FILE}

# generate cool file
cooler cload pairs -c1 2 -p1 3 -c2 4 -p2 5 ${BIN_FILE} ${PAIR} ${COOLER_OUT}/${prefix}.cool

# normalization with ICE
#cooler balance -p ${THREADS} --ignore-diags 0 --min-nnz 1 --max-iters 1000 ${COOLER_OUT}/${prefix}.cool

# output raw and norm
cooler dump -t pixels ${COOLER_OUT}/${prefix}.cool > ${MAXHIC_IN}/${prefix}.matrix

#cooler dump -t pixels --header -b --na-rep 0 ${COOLER_OUT}/${prefix}.cool > ${COOLER_OUT}/${prefix}_norm.matrix

# remove srot_pair
#rm ${SORT_PAIR}
#rm ${SORT_PAIR}.px2
