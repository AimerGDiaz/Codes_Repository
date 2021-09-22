cd "$1"Fastq/
> "$1"Results/Statistics/Total_stats.txt
#awk 'BEGIN {OFS = "\n"}{ header = $0 ; getline seq ;getline qname; getline qseq
for library in `ls *fastq | egrep -v "_ne|reduced"`
 do
	name=`basename -s ".fastq" $library`
	raw_number_seq=` awk '/^Total Sequences/ {print $3}' Quality/$name"_fastqc/fastqc_data.txt"` 
	raw_size=`ls -lh $library | awk '{print $5}' `
	reduced_number_tag=` awk '/^Total Sequences/ {print $3}' Quality/$name".reduced_fastqc/fastqc_data.txt"`
	reduced_number_seq=` grep -P "^@.*$name" $name".reduced.fastq" | awk  '{gsub(".*_","",$0); sum+=$0} END {print sum}' `
	reduced_size=`ls -lh $name".reduced.fastq"  | awk '{print $5}' `
	tmm_size=`ls -lh $name"_trim.fq" | awk '{print $5}' `
	tmm_number_tag=`awk '/^Total Sequences/ {print $3}' Quality/$name"_trim_fastqc/fastqc_data.txt" `
	tmm_number_seq=`grep -P "^@.*$name" $name"_trim.fq" | awk  '{gsub(".*_","",$0); sum+=$0} END {print sum}' `
        ms_size=`ls -lh $name"_reduced_cor.fq" | awk '{print $5}' `
        ms_number_tag=`awk '/^Total Sequences/ {print $3}' Quality/$name"_reduced_cor_fastqc/fastqc_data.txt" `
	ms_number_seq=`grep -P "^@.*$name" $name"_reduced_cor.fq" | awk  '{gsub(/_S_final$|_S_noise$/,"",$0); gsub(".*_","",$0);  sum+=$0} END {print sum}' `	
 	percentage=`echo $raw_number_seq | awk  -v val2="$reduced_number_tag" '{print ((val2 * 100)/$1)}'`
 
	echo -ne "$name\t$raw_number_seq\t$raw_size\t$reduced_number_seq\t$reduced_number_tag ($percentage%)\t$reduced_size\t$tmm_size\t$tmm_number_tag\t$tmm_number_seq\t$ms_size\t$ms_number_tag\t$ms_number_seq\n"   >>  "$1"Results/Statistics/Total_stats.txt 
	parallel --jobs 5 ' gzip {} ' ::: $name*q #$name.*reduced.fastq
	rm $name*fastqtab.txt 2>/dev/null
 done #  >>  "$1"Results/Statistics/Total_stats.txt

	sed -i '1s/^/Library\tNo_seq_raw\tSize_raw\tNo_seq_reduced\tNo_tag_reduced\tSize_reduced\tSize_trimmomatic\tNo_tag_tmm\tNo_seq_tmm\tSize_miRNA-Saver\tNo_tag_ms\tNo_seq_ms\n/' "$1"Results/Statistics/Total_stats.txt



