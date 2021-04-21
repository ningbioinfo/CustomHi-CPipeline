#!/bin/bash
R1_URLs=$1
NAME=$2
BWA_INDEX=$3
OUT_DIR=$4

RAW_DATA_DIR=${OUT_DIR}/${NAME}_out/raw_data/
TRIM_DIR=${OUT_DIR}/${NAME}_out/trimmed_data/
MAP_DIR=${OUT_DIR}/${NAME}_out/mapped_data/

if [ -f ${MAP_DIR}/${NAME}_trimmed_sortedn.bam ] ;
then
echo "sample ${NAME} has been processed before. Exiting..."
exit 1
fi

echo ${NAME}

mkdir -p $RAW_DATA_DIR
mkdir -p $TRIM_DIR
mkdir -p $MAP_DIR

#submit download job in multiple lane mode - which download the data and then merge them together.
echo $R1_URLs | tr ';' '\n' > ${RAW_DATA_DIR}/R1_templinks

n=0
for link in $(cat ${RAW_DATA_DIR}/R1_templinks); do
  n=$(( n + 1 ))
  sbatch slurm_download_fastq.sh ${link} ${RAW_DATA_DIR} ${NAME}_${n} >> tempfile
done

job_ids=$(cut -d ' ' -f4 tempfile | cat | tr '\n' ':')

download_job_id=$(echo ${job_ids%":"})

rm tempfile

# submit concat job

sbatch --dependency=afterok:${download_job_id} slurm_merge_MB_FASTQ.sh ${RAW_DATA_DIR} ${NAME} > tempfile

merge_job_id=$(head -n1 tempfile | cut -d ' ' -f4)

#submit trimming job
sbatch --dependency=afterok:${merge_job_id} slurm_trimming.sh ${RAW_DATA_DIR}/${NAME}_R1.fastq.gz $TRIM_DIR > tempfile

trim_job_id=$(head -n1 tempfile | cut -d ' ' -f4)

rm tempfile

#submit alignment job
sbatch --dependency=afterok:${trim_job_id} slurm_bwa.sh ${BWA_INDEX} ${TRIM_DIR}/${NAME}_trimmed_R1.fastq.gz ${MAP_DIR} > tempfile

map_job_id=$(head -n1 tempfile | cut -d ' ' -f4)

rm tempfile

# post alignment
bash PostAlignment.sh ${NAME} HiC_datasets_raw_fixedname.csv 16 10000 ${OUT_DIR} ${map_job_id}
