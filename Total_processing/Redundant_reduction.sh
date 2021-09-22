
> "$1"Results/Statistics/Empty_seqs.txt
cd "$1"/Fastq 
files=( `ls   *"$2" ` )


g=$3 
for ((i=0; i < ${#files[@]}; i+=g))
do
	part=( "${files[@]:i:g}" )
	for library in ${part[@]}
	do
	{ 
	name=`basename -s "$2" $library`
	empty_seq=`grep -c  ^$ $library`
	if [ "$empty_seq" -gt 0 ]; 
	then
	echo -ne "$name\t$empty_seq\n" >> "$1"Results/Statistics/Empty_seqs.txt
	awk 'gsub(/^$/,/N/,$0)0' $library > $name"_ne.fastq"
	library=$name"_ne.fastq"	
#	else 
#	rm "$1"Results/Statistics/Empty_seqs.txt
	fi

	awk ' BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; print seq"\t"qheader"\t"qseq}' $library  > $name"_fastqtab.txt"
	library=$name"_fastqtab.txt"
	
	awk -F'\t' ' BEGIN {OFS = "\t"} {seq = $1; qseq = $3; dups[seq]++ }  END {for (num in dups) {print dups[num]"\t"num}}' $library > $name"_counts.txt"
	 
	grep -vP "^1\t" $name"_counts.txt"  | cut -f 2 > $name"_dupseqs.txt" 
#        quality=`awk 'NR%4==0 {printf $0}'  $library  | tr -d '\n' | hexdump -v -e '/1 "%u\n"' |  head -n1000000  | sort -un | head -n +1`
 
	rm   $name"_counts.txt" 
	perl /scr/hercules1san/aigutierrez/Total_Preprocessing/reads_redundant_reduction_tabular.pl $library $name"_dupseqs.txt" 	
	rm  $name"_dupseqs.txt"  $library
	
 	} & 
	done
	wait 
done  
