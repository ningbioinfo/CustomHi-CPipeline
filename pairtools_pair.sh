#!/bin/bash

BAM=$1
prefix=$(basename ${BAM} _trimmed_sortedn.bam)
CHR_SIZES=$2
THREADS=$3
OUTDIR=$4

pairtools parse --drop-sam --min-mapq 30 ${BAM} -c ${CHR_SIZES} --add-columns mapq | pairtools sort --nproc ${THREADS} | pairtools dedup --output-stats ${OUTDIR}/${prefix}.pairs.stat | pigz -p ${THREADS} > ${OUTDIR}/${prefix}.valid.pairs.gz
