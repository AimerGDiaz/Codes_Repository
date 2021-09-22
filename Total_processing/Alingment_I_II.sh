# $1 "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/"
# $2 alinger 
# $3 fyle type 
# $4 cores
# $5 genome
#
if [ "$3" == "tmm" ] 
then 
file_type="_trim.fq"    
elif [ "$3" == "ms" ] 
then
file_type="_reduced_cor.fq"
else
file_type=".reduced.fastq"
fi

	echo "Alingnment of the fastq files $3 using the alinger $2 " 
bash /scr/hercules1san/aigutierrez/Code/Multimapping_2017/all_aligners.sh "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/" $2 $file_type $4 $3 $5
	echo "3' removal of the unmapped fastq files $3 using the alinger $2 " 	
bash /scr/hercules1san/aigutierrez/Total_Preprocessing/Noise_dirty_remove.sh "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/" $2 $3 $4

	echo "Second Alingnment of the fastq files $3 using the alinger $2 " 
bash /scr/hercules1san/aigutierrez/Total_Preprocessing/all_aligners.sh "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/Results/"$2"/Bam/Unmapped/" $2 "_"$3"_dr.fq" $4 $3"_RA" $5 RA
 
 basic_dir=`echo $1 | cut -d '/' -f 1-6`
 if [ "$4" == "raw" ] 
 then
 echo All mapping process is finished 
 echo Finishing > "$basic_dir"_TA.txt
 fi
