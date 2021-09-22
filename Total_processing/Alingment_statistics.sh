cd "$1"Fastq/
> "$1"Results/Statistics/Alingnment_stats_Bwa.txt
> "$1"Results/Statistics/Alingnment_stats_Bowtie.txt
> "$1"Results/Statistics/Alingnment_stats_Bowtie2.txt
> "$1"Results/Statistics/Alingnment_stats_Segemehl.txt
> "$1"Results/Statistics/Alingnment_stats_Bwa_mirna.txt
> "$1"Results/Statistics/Alingnment_stats_Bowtie_mirna.txt
> "$1"Results/Statistics/Alingnment_stats_Bowtie2_mirna.txt
> "$1"Results/Statistics/Alingnment_stats_Segemehl_mirna.txt




for library in `ls *log`
 do
	name=`basename -s ".log" $library`
	aln_ms_seqs=()
	aln_ms_tags=()
	aln_raw_seqs=()
	aln_raw_tags=()
	aln_tmm_tags=()
	aln_tmm_seqs=()
      	aln_ms_seqs_mirna=()
      	aln_ms_tags_mirna=()
      	aln_raw_seqs_mirna=()
      	aln_raw_tags_mirna=()
      	aln_tmm_tags_mirna=()
      	aln_tmm_seqs_mirna=()

	for alinger in Bwa Bowtie Bowtie2 Segemehl
	do
#744_Control_ms_total.bam
{
	aln_ms_seqs+=(`samtools view  "$1"Results/$alinger/Bam/$name"_ms_total.bam" | awk '{gsub(/_S_final$|_S_noise$/,"",$1); gsub(".*_","",$1);  sum+=$1} END {print sum}' `)
	aln_ms_tags+=(`samtools view  "$1"Results/$alinger/Bam/$name"_ms_total.bam" | wc -l `)
	aln_raw_seqs+=(`samtools view  "$1"Results/$alinger/Bam/$name"_raw_total.bam" | awk '{gsub(/_S_final$|_S_noise$/,"",$1); gsub(".*_","",$1);  sum+=$1} END {print sum}' `)
	aln_raw_tags+=(`samtools view  "$1"Results/$alinger/Bam/$name"_raw_total.bam" | wc -l `)
	aln_tmm_seqs+=(`samtools view  "$1"Results/$alinger/Bam/$name"_tmm_total.bam" | awk '{gsub(/_S_final$|_S_noise$/,"",$1); gsub(".*_","",$1);  sum+=$1} END {print sum}' `)
       	aln_tmm_tags+=(`samtools view  "$1"Results/$alinger/Bam/$name"_tmm_total.bam" | wc -l `)
aln_ms_seqs_mirna+=( `awk '{sum=0;sum+=$5} END {print sum}' "$1"Results/$alinger/Bam/Mirna/$name"_ms.miRNA.bed" `  )
aln_ms_tags_mirna+=( `samtools view  "$1"Results/$alinger/Bam/Mirna/$name"_ms.miRNA.bam" | wc -l ` )
aln_raw_seqs_mirna+=( `awk '{sum=0;sum+=$5} END {print sum}' "$1"Results/$alinger/Bam/Mirna/$name"_raw.miRNA.bed" ` )
aln_raw_tags_mirna+=(`samtools view  "$1"Results/$alinger/Bam/Mirna/$name"_raw.miRNA.bam" | wc -l ` )
aln_tmm_tags_mirna+=( `awk '{sum=0;sum+=$5} END {print sum}' "$1"Results/$alinger/Bam/Mirna/$name"_tmm.miRNA.bed" `  )
aln_tmm_seqs_mirna+=(`samtools view  "$1"Results/$alinger/Bam/Mirna/$name"_tmm.miRNA.bam" | wc -l `)
#
rm "$1"Results/$alinger/Bam/"$name"_*.mapped.bam* 
rm "$1"Results/$alinger/Bam/"$name"_*_RA.mapped.bam*
	echo -ne "$name\t${aln_raw_seqs[@]}\t${aln_raw_tags[@]}\t${aln_ms_seqs[@]}\t${aln_ms_tags[@]}\t${aln_tmm_seqs[@]}\t${aln_tmm_tags[@]}\n" | tr ' ' '\t' >> "$1"Results/Statistics/Alingnment_stats_"$alinger".txt
echo -ne "$name\t${aln_ms_seqs_mirna[@]}\t${aln_ms_tags_mirna[@]}\t${aln_raw_seqs_mirna[@]}\t${aln_raw_tags_mirna[@]}\t${aln_tmm_seqs_mirna[@]}\t${aln_tmm_tags_mirna[@]}\n" | tr ' ' '\t' >> "$1"Results/Statistics/Alingnment_stats_"$alinger"_mirna.txt 
}&

done
wait 

 done #  >>  "$1"Results/Statistics/Total_stats.txt
sed -i '1s/^/Library\tNo_seqs_raw_bwa\tNo_tags_raw_bwa\tNo_seqs_ms_bwa\tNo_tags_ms_bwa\tNo_seqs_tmm_bwa\tNo_tags_tmm_bwa\n/' "$1"Results/Statistics/Alingnment_stats_Bwa.txt
sed -i '1s/^/Library\tNo_seqs_raw_bwa\tNo_tags_raw_bwa\tNo_seqs_ms_bwa\tNo_tags_ms_bwa\tNo_seqs_tmm_bwa\tNo_tags_tmm_bwa\n/' "$1"Results/Statistics/Alingnment_stats_Bwa_mirna.txt
sed -i '1s/^/Library\tNo_seqs_raw_bowtie\tNo_tags_raw_bowtie\tNo_seqs_ms_bowtie\tNo_tags_ms_bowtie\tNo_seqs_tmm_bowtie\tNo_tags_tmm_bowtie\n/' "$1"Results/Statistics/Alingnment_stats_Bowtie.txt "$1"Results/Statistics/Alingnment_stats_Bowtie_mirna.txt 
sed -i '1s/^/Library\tNo_seqs_raw_bowtie2\tNo_tags_raw_bowtie2\tNo_seqs_ms_bowtie2\tNo_tags_ms_bowtie2\tNo_seqs_tmm_bowtie2\tNo_tags_tmm_bowtie2\n/' "$1"Results/Statistics/Alingnment_stats_Bowtie2.txt "$1"Results/Statistics/Alingnment_stats_Bowtie2_mirna.txt
sed -i '1s/^/Library\tNo_seqs_raw_segemehl\tNo_tags_raw_segemehl\tNo_seqs_ms_segemehl\tNo_tags_ms_segemehl\tNo_seqs_tmm_segemehl\tNo_tags_tmm_segemehl\n/'  "$1"Results/Statistics/Alingnment_stats_Segemehl.txt "$1"Results/Statistics/Alingnment_stats_Segemehl_mirna.txt

