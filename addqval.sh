#!/bin/bash
infile=$1
outfile=$2

python qvalue_generator.py ${infile} ${outfile}

pigz -p 16 ${outfile}

