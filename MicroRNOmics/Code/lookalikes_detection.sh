# echo "query subject %id alignment_length mismatches gap query_start query_end subject_start subject_end E_value bit_score"

#sub alignmnets

name=`basename -s ".bed" $1`
#awk '{if ($11 == 0 && $12 == 0) {$7="MI_MinorLK"; $8=(($8+$9)/2);print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8}}'  $1 > $name.cor.bed
awk '{if ($11 == 0 && $12 == 0) {$7="MI-MinorLK"; $8=($3-$2);print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8}}'  $1 > $name.cor.bed & 
#awk '{if ($9 > $8 && $11 == 0) {$7="MI_MajorLK"; $8=(($8+$9)/2);print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8}}'  $1 >> $name.cor.bed
awk '{if ($9 > $8 && $11 == 0) {$7="MI-MajorLK"; $8=($3-$2);print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8}}'  $1 >> $name.cor.bed & 
wait 
#mv $1 /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Lookalikes 
#real length alignments 


