
cd "$1"Fastq
files=( `ls  *$2` ) #|  awk -v lim_inf="$start" -v lim_sup="$end" '{if (NR > lim_inf && NR <= lim_sup ) print }'` ) 
#g=`ls *.fastq | wc `
g=$3
for ((i=0; i < ${#files[@]}; i+=g))
do
  part=( "${files[@]:i:g}" )
        for library in ${part[@]}
        do
        {
	name=`basename -s "$2" $library`
#	echo Fastq to tab conversion of $name
#awk 'BEGIN {OFS = "\n"}{ header = $0 ; getline seq ;getline qname; getline qseq; news=substr(seq,7); if (length(news) >= 15 ) print header, news, "+",substr(qseq,7) }'	
#	awk ' BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; print seq"\t"qheader"\t"qseq}' $library  > $name"_fastqtab.txt"
	if [ -f "$1"Specific_Code/true_adapters_finded.txt   ] 
        then
	echo Clipping adapters in $name 
	perl /scr/hercules1san/aigutierrez/Total_Preprocessing/adapter_clipper.pl $library "$1"Specific_Code/true_adapters_finded.txt 
# 	awk 'BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) >= 15 ) {print header, seq, qheader, qseq}}' $library  >  $name.cor.fastq
#	filter="$name"_ar_fastqtab.txt
#        else
  #      filter=$name"_fastqtab.txt"
        fi

#        echo filtering seqs lower than 15 of  $name
##	awk -F'\t' 'BEGIN {OFS = "\t"} {seq = $1; qseq = $3; if (length(seq) >= 15 ) {print seq, "+", qseq}}'  $name"_fastqtab.txt" >  $name"_cor_fastqtab.txt" 
	}&
        done
        wait
done
