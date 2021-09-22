#cp /usr/local/FastQC/Contaminants/contaminant_list.txt .
cp /usr/local/FastQC/Configuration/contaminant_list.txt "$1"Specific_Code/ 
#V/scr/hercules1san/aigutierrez/Alzheimer_miRNA/Alzheimer_Col
awk '/>>Overrepresented/ {flag=1;next; next} /^>>END_MODULE/{flag=0} flag ' "$1"Fastq/Quality/*/fastqc_data.txt  | grep -v Count | grep -v "No Hit" | cut -f 1  | sort  | uniq -c | awk '{print $1"\t"$2}' | awk '{print ">overrepresented_seq_"NR"_"$1"_times""\n"$2}' > "$1"Specific_Code/Total_overrepresented_seqs.fa
#
cd "$1"Specific_Code/ 
awk '/# the program can benefit./{flag=1;next; next} /^>>END_MODULE/{flag=0} flag ' contaminant_list.txt|   tr ' ' '_'  | tr '\t' ' '  | awk '{print $2}' | grep -v "^$"  > contaminant_list.list
sort contaminant_list.list  | uniq -u > contaminant_list_uq.txt 
sort contaminant_list.list  | uniq -d >> contaminant_list_uq.txt
rm contaminant_list.list 

#rm adapters_finded.txt 2>/dev/null
echo > adapters_finded.txt
for adapter in `cat contaminant_list_uq.txt`
do 
	sub_adapters=(`echo $adapter | awk 'old=$0; new=$0; {for (i=7;i<=length(old);i+=1) {print substr(new,1,i); print substr(new,length(old)-i,length(old))}}' | grep -v $adapter `) 
	for sadap  in  ${sub_adapters[@]} 
	do 
	if [ `grep -c $sadap  Total_overrepresented_seqs.fa` -ne "0" ] 
#	if [ `grep -c $sadap - ]

	then

#	echo -ne "Found  substring $sadap from the adapter  $adapter \n " # is found "
	echo -ne "$sadap\n" >> adapters_finded.txt 
	
	fi  
	done 
done 

#rm contaminant_list_uq.txt

if [ -f adapters_finded.txt ]
then
sort adapters_finded.txt | uniq  > a ; mv a adapters_found.txt


awk -v s=1 'NR>1{print ">Adapter_"s"_"length($0)"\n"$1; s++}'  adapters_found.txt  > adapters_found.fa
grep ">" adapters_found.txt  | tr -d '>' > rest_list

bwa aln -n 0 -o 0 -e 0 -l 8 -k 0 -t 8 /scr/hercules1san/genomes/Homo_sapiens/hg19/hg19 adapters_finded.fa > adapters_finded.sai

bwa samse /scr/hercules1san/genomes/Homo_sapiens/hg19/hg19 adapters_finded.sai adapters_finded.fa > adapters_finded.sam 

awk 'OFS="\t"{if ($1 ~ /^Adapter*/  && $2 != 4) print $1}' adapters_finded.sam > adapters_finded.rep
rm adapters_finded.sai adapters_finded.sam 

###---------------------Blast strategy omitted 
#perl /scr/hercules1san/aigutierrez/Total_Preprocessing/split_fasta_groups.pl $2  adapters_finded.fa

#parallel --jobs 6  'blastn -word_size  6 -query {} -subject /scr/hercules1san/genomes/Homo_sapiens/hg19/hg19.fa -outfmt 6 -out adapters_finded.out 2>adapters_finded.error ' ::: *group*.fa 

#awk 'OFS="\t"{length_s=$1; gsub(".*_","",length_s); if ($3 == 100 && (length_s-2) <= $4)   print $1}' adapters_finded.out   | sort | uniq  > adapters_finded.rep
#rm *group*.fa
sort adapters_finded.rep rest_list  | uniq -u > adapters_finded.t.txt

grep -A 1 --no-group-separator -f adapters_finded.t.txt adapters_finded.fa | grep -v ">"  > true_adapters_finded.txt
rm adapters_finded.txt adapters_finded.rep rest_list adapters_finded.t.txt #adapters_finded.out  
#cat adapters_finded.fa | parallel --block 2k --recstart '>' --pipe  blastn -word_size  6 -query - -subject /scr/hercules1san/genomes/Homo_sapiens/hg19/hg19.fa -outfmt 6 -out adapters_finded.out 2>adapters_finded.error &


#list=(`cat adapters_finded.txt`)
#g=$2
#for ((i=0; i < ${#list[@]}; i+=g))
#do 
#part=( "${list[@]:i:g}" )
#for f in  ${part[@]}
#         do
#	{
#	length=`echo -ne $f | wc -c  `
#        blastn -word_size `echo $(( $length - 3 ))` -query <(echo -e ">Name\n"$f) -subject /scr/hercules1san/genomes/Homo_sapiens/hg19/hg19.fa -outfmt 6 -out $f.out
#	blast_score=`awk '{print $3}' $f.out | head -n +1`
#	blast_length=`awk -v length_test="$length"  'NR==1{len=($8+1)-$7;  print len}' $f.out`
#
#	echo ----- blast_score is $blast_score and blast_length $blast_length , while the length of the  candidate adapter is $length
#	        head -n +1 $f.out
#
#                if [ "$blast_score" == "100.00" ]  && [ "$blast_length" == "$length" ] 
#                then
#        echo "warning the adapter string $f in available in the genome" 
#                else
#        echo "The adapter string $f is not in the genome"
#        echo $f >> true_adapters_finded.txt
#                fi
#	rm $f.out 
#	}&
#        done
#	wait 
#done

#rm adapters_finded.txt
else
echo There is not adapters in the data 
fi
#rm   Total_overrepresented_seqs.fa 
#head true_adapters_finded.txt
awk -F'A|C|G|T|N' '{print NF,$0}' true_adapters_finded.txt | sort -k 1rn  | awk '{print $2}'  > a; mv a true_adapters_finded.txt
#head true_adapters_finded.txt
 
