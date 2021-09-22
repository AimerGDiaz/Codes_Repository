#cd /scr/altair/aigutierrez/Tesis_Maestria/Data/$1/Fastq

cd  $1
#files=( `ls  *.fastq.gz` )
#files=(`ls  *_trim.fq` )
files=(`ls *$2` )
mkdir Quality 2>/dev/null
g=5
for ((i=0; i < ${#files[@]}; i+=g))
do
  part=( "${files[@]:i:g}" )
        for library in ${part[@]}
        do
        {
        echo fastqc analysis of  $library
#	name=` echo $library | perl -ne '$_ =~ s/(.*)\.fastq(\.gz)?/$1/;print $1."\n";'`
	name=`basename -s "$2" $library`
#	echo $name
#        fastqc -q $library -o /scr/altair/aigutierrez/Tesis_Maestria/Data/$1/Fastq/Quality  2>/dev/null 
         fastqc -q $library -o "$1"Quality
	}&
        done
        wait
done

#cd /scr/hercules1san/aigutierrez/Alzheimer_miRNA/Alzheimer_Col/Fastq/Quality
cd "$1"Quality
#.reduced_fastqc.zip
	parallel --jobs 8 ' unzip -q {} 
	rm {} 2>/dev/null ' ::: *.zip

#rm /scr/altair/aigutierrez/Tesis_Maestria/Data/$1/Fastq/Quality/*_fastqc.zip


