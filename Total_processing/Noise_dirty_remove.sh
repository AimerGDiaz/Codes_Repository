#!/bin/bash
# bash 3Noise_removal.sh Hepatitis Bwa 6
cd "$1"Results/"$2"/Bam/Unmapped
 parallel --jobs $4 ' name=$(basename -s ".fq.gz" {})
 bash /scr/hercules1san/aigutierrez/Total_Preprocessing/dirty_remove.awk {} $name  ' ::: *$3.fq.gz 





















































