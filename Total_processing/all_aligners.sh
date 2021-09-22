#bash /scr/hercules1san/aigutierrez/Code/Multimapping_2017/all_aligners.sh  /scr/hercules1san/aigutierrez/Total_Preprocessing/Hepatitis/Results/Bwa/Bam/Unmapped/test/ Bwa  _tmm_mir_2.fq 8 tmm_RA /scr/hercules1san/genomes/Homo_sapiens/hg19/hg19 RA 
#bash all_aligners.sh work_dir ALigner files_suffix cores additional_name genome 
if [ "$7" == "RA" ]
then
cd $1
basic_dir=`echo $1 | cut -d '/' -f 1-6`
> "$basic_dir"/Results/$2/Time_remapping.txt
time_dir="Time_remapping.txt"
else
cd "$1"Fastq
mkdir "$1"Results/$2 "$1"Results/$2/Bam "$1"Results/$2/Bam/Unmapped  "$1"Results/$2/Bam/Mirna "$1"Results/$2/Bam/Ncrna 2>/dev/null
basic_dir="$1"
> "$1"Results/$2/Time_mapping.txt
 time_dir="Time_mapping.txt"
fi



for f in `ls *"$3"`
do 
NAME=`basename -s "$3" $f `
NAME=$NAME"_"$5

echo "Starting the alignment of $NAME against human genome"
echo $NAME >>  $basic_dir/Results/$2/$time_dir
 
quality1=`awk 'NR%4==0 {printf $0}'  $f  | tr -d '\n' | hexdump -v -e '/1 "%u\n"' |  head -n1000000  | sort -un | head -n +1`
quality2=`awk 'NR%4==0 {printf $0}'  $f  | tr -d '\n' | hexdump -v -e '/1 "%u\n"' |  head -n1000000  | sort -un | tail  -n 1`

if [ "$2" == "Bwa" ]
then 
qpar=`echo $quality1 | awk  '{if ($1 >= 32 && "$quality2" <= 75 ) qv=""; else qv="-I"; print qv}'`
{ time bwa aln -n 0 $qpar -o 0 -e 0 -l 8 -k 0  -t $4 $6  $f >  $basic_dir/Results/$2/$NAME.sai 2>  $basic_dir/Results/$2/$NAME.log  ; } 2>> $basic_dir/Results/$2/$time_dir
bwa samse $6 $basic_dir/Results/$2/$NAME.sai $f > $basic_dir/Results/$2/$NAME.sam 2>/dev/null
rm $basic_dir/Results/$2/$NAME.sai
elif [ "$2" == "Bowtie2" ]
then
qpar=`echo $quality1 | awk  '{if ($1 >= 32 && "$quality2" <= 75 ) qv="--phred33"; else qv="--phred64"; print qv}'`
{ time bowtie2 --local -p $4 $qpar -D 20 -R 3 -N 0 -L 20 -i S,1,0.50  -x $6  $f  -S  $basic_dir/Results/$2/$NAME.sam 2>  $basic_dir/Results/$2/$NAME.log ; } 2>> $basic_dir/Results/$2/$time_dir
elif [ "$2" == "Bowtie" ]
then
qpar=`echo $quality1 | awk  '{if ($1 >= 32 && "$quality2" <= 75 ) qv="--phred33-quals"; else qv="--phred64-quals"; print qv}'`
{ time bowtie -n 0 -e 1 -p $4 -l 8 -m 200 -a --best --strata $qpar --chunkmbs 20000 -S $6 $f > $basic_dir/Results/$2/$NAME.sam 2>  $basic_dir/Results/$2/$NAME.log  ; } 2>> $basic_dir/Results/$2/$time_dir
elif [ "$2" == "Segemehl" ]
then
{ time /scr/hercules1san/aigutierrez/Code/Aligners_characterization/finalexport/segemehl.x -d "$6".fa -i "$6".idx -q $f -t $4 -E 25 -A 100 -M 200 -o  $basic_dir/Results/$2/$NAME.sam 2> $basic_dir/Results/$2/$NAME.log ; } 2>>  $basic_dir/Results/$2/$time_dir

fi 
done 

 parallel --jobs 2 ' NAME=`basename -s "'$3'" {}` 
 NAME=$NAME"_"'$5';  
 echo "Converting from sam to bam $NAME "
samtools view -bS ' $basic_dir'/Results/'$2'/$NAME.sam | samtools sort - '$basic_dir'/Results/'$2'/Bam/$NAME ' ::: *$3

# awk 'OFS="\n"{if (\$2 == "4") print "@"\$1,\$10,"+",\$11  }' '$basic_dir'/Results/'$2'/$NAME.sam >  '$basic_dir'/Results/'$2'/Bam/Unmapped/$NAME.fq
 parallel --jobs 8 ' NAME=`basename -s "'$3'" {}` 
 NAME=$NAME"_"'$5';
 echo "Extracting real mapped from $NAME " 
 bash /scr/hercules1san/aigutierrez/Total_Preprocessing/bam2fastq.awk  '$basic_dir'/Results/'$2'/$NAME.sam >  '$basic_dir'/Results/'$2'/Bam/Unmapped/$NAME.fq 
 samtools view -F 4 -h -b '$basic_dir'/Results/'$2'/Bam/$NAME.bam >  '$basic_dir'/Results/'$2'/Bam/$NAME.mapped.bam
 gzip  -f '$basic_dir'/Results/'$2'/Bam/Unmapped/$NAME.fq 
 echo "Indexing final bam $NAME"
 rm '$basic_dir'/Results/'$2'/$NAME.sam
 rm '$basic_dir'/Results/'$2'/Bam/$NAME.bam
 cd '$basic_dir'/Results/'$2'/Bam/
 samtools index $NAME.mapped.bam ' ::: *$3

 if [ "$4" == "raw" ] 
 then
 echo Finishing > "$basic_dir"_1A.txt
 fi
