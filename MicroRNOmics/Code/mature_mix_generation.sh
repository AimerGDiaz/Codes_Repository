cd /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases 

echo "Extract no-hsa miR previously unannotated "

for f  in `awk '{print $2}' /scr/hercules1san/aigutierrez/MicroRNOmics/Results/names_equivalence.txt | sort | uniq | grep -v hsa ` 
 do
 mir=`echo $f | awk '{gsub("mir","miR",$1); print $1}'`
  if ! grep -w -A 1 $mir /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/mature_v21.fa 
	 then cor=` echo $mir | awk -F '-' '{print $1"-"$2"-"$3}'`
	 grep -A 1 $cor /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/mature_v21.fa  
  fi
 done > mature_v21_additions.fa

echo "mix of mature v20 and mature v21"

for f in `grep -v ">" /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis/mature_v20_hsa.fa`
  do
 if ! grep -qwB 1 $f   /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis/mature_v21_hsa.fa 
 then 
 grep --no-group-separator -wB  1 $f /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis/mature_v20_hsa.fa
 fi
done  > excluded_miRs_v21.fa


cat /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis/mature_v21_hsa.fa excluded_miRs_v21.fa  mature_v21_additions.fa  > mature_mix.fa

rm excluded_miRs_v21.fa mature_v21_additions.fa 

echo "Reducing seq redundancy" 
awk 'BEGIN {OFS = "\t"} {header = $0 ; getline seq ; gsub(" .*", "", header); gsub("U","T",seq); print header, seq}' mature_mix.fa  > mature_mix.cor.txt

rm mature_mix.fa 
cut -f 2 mature_mix.cor.txt | sort | uniq -d  >  exclude.txt

grep -vf exclude.txt mature_mix.cor.txt   |  awk '{print $1"\n"$2}' > mature_mix.uq.fa 

for f  in `cat  exclude.txt` 
 do
 grep -w  $f mature_mix.cor.txt | cut -f 1 | tr -d '>' | tr '\n' ';' | awk -F ';$' '{print ">"$1}'  
 echo $f
 done  > exclude.fa
 rm exclude.txt
#for f  in `cat  exclude.txt`; do grep -w  $f   | cut -f 1 | tr -d '>' | tr '\n' ';' | awk -F ';$' '{print ">"$1}' ; echo $f ; done  > exclude.fa


cat mature_mix.uq.fa exclude.fa  > mature_mix.uqcor.fa
rm  mature_mix.uq.fa exclude.fa 

echo "reducing redundancy due to  complementary reverse "
blastclust -i mature_mix.uqcor.fa -p F -S 100 -L .99 -b T -W 10 |  awk '{gsub(" h","_h",$0)}{print $0}'  |  grep  "_"   > mature_mix.clus

#rm mature_mix.*n*

cd /scr/hercules1san/aigutierrez/MicroRNOmics/Code 

 bash test_cluster_identity_massive.sh mature_mix /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases/mature_mix.clus
cd /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases

mv /scr/hercules1san/aigutierrez/MicroRNOmics/Results/mature_mix.clus.txt . 

cut -f 1 mature_mix.clus.txt | tr ' ' '\n'  > exclude.txt 

awk 'BEGIN {OFS = "\t"} {header = $0 ; getline seq; print header,seq}' mature_mix.uqcor.fa > mature_mix.uqcor.txt

grep -vf exclude.txt  mature_mix.uqcor.txt |awk '{print $1"\n"$2}' >  mature_mix.uqcor.uq.fa

 while read clus
 do
 mir=`echo $clus | awk '{print $2}'` 
 mir2=`echo $clus | awk '{print $1}'`
 echo ">"$mir";"$mir2"(dual-sense)"
 grep -w $mir mature_mix.uqcor.txt | cut -f 2 
 done <mature_mix.clus.txt  > mature_mix.dual_sense.fa 

cat mature_mix.uqcor.uq.fa  mature_mix.dual_sense.fa  > mature_mix.final.fa

rm mature_mix.uqcor.uq.fa mature_mix.dual_sense.fa exclude.txt mature_mix.uqcor.txt mature_mix.uqcor.fa

echo "Aligning the mature mix fa to the human genome and against the hairpin database" 

bowtie-build /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.final.hairpin_loci.fasta  hairpin_database
ssh hercules4 bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/mapping_hg19_mature_bowtie_exact.sh

echo "Selecting matures seq for each hairpin" 

intersectBed -loj -s -a hg19_mature_bowtie.bed -b ../../Results/hg19_hairpin_complete.final.bed   |grep -Pv "\t-1\t" |  awk 'OFS="\t"{print $1, $2,$3, $4, $10, $6, ($3-$2)  }'  > /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_mature.bed

intersectBed -v -s -b hg19_mature_bowtie.bed -a ../../Results/hg19_hairpin_complete.final.bed   > hairpins_wo_mature.bed

intersectBed -v -s -a hg19_mature_bowtie.bed -b ../../Results/hg19_hairpin_complete.final.bed  > /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_nonmiRNA_space.bed
#only to check consistency of  mapping to hairpin and mapping to total genome
#awk -F'_' 'OFS="\t"{print $1,$2,$3,$4,$5,$6}' hairpin_mature_bowtie.bed  | awk 'OFS="\t"{if ($11 == "+") { if ($5 == "+") {$2=($2+$7); $3=($2+$8)}  else {$2=($3-$8); $3=($3-$7)}; print $1, $2,$3, $9, $4, $5, ($3-$2) } }'  > hairpin_mature_bowtie.hg19.bed
awk -F'_' 'OFS="\t"{print $1,$2,$3,$4,$5,$6}' hairpin_mature_bowtie.bed  | awk 'OFS="\t"{if ($11 == "+") { if ($5 == "+") {$2=($2+$7); $3=($2+$8)}  else {$2=($3-$8); $3=($3-$7)}; print $1, $2,$3, $9, $4, $5, ($3-$2) } else { if (/dual-sense/) {if ($5 == "+") {$2=($2+$7); $3=($2+$8)}  else {$2=($3-$8); $3=($3-$7)}; print $1, $2,$3, $9, $4, $5, ($3-$2) }}}'   > hairpin_mature_bowtie.hg19.bed


intersectBed -v -s   -a hairpin_mature_bowtie.hg19.bed -b ../../Results/hg19_mature.bed 

awk -F'_' 'OFS="\t"{print $1,$2,$3,$4,$5,$6}' hairpin_mature_bowtie.bed  | awk 'OFS="\t"{if (!/dual-sense/) {if ( $11 != "+") print $1,$2,$3,$9,$4"("$11")",$5 }}'  > hairpin_mature_rare_sense.bed

cd /scr/hercules1san/aigutierrez/MicroRNOmics/Results/
  bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/order_bed.sh hg19_mature.bed

#correct problem 
#mergeBed -i hg19_mature.bed -s -nms  -scores collapse | grep "," 
echo "Solving mature overlapping (but also detecting new 5p and 3p miRs " 
mergeBed -i hg19_mature.bed -s -nms  -scores collapse | grep "," | awk 'OFS="\t"{print $0,($3-$2)}' > mature_overlap.bed
intersectBed  -v -s -a hg19_mature.bed -b  mature_overlap.bed  > mature_no_overlap.bed 
cat mature_no_overlap.bed  mature_overlap.bed > hg19_mature.final.bed
rm mature_overlap.bed mature_no_overlap.bed 
bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/order_bed.sh hg19_mature.final.bed 

#check mergeBed -i hg19_mature.final.bed -s -nms  -scores collapse -n  | grep -Pv "\t1"
###
perl /scr/hercules1san/aigutierrez/MicroRNOmics/Code/hsa_mir_extraction.pl  /scr/hercules1san/genomes/Homo_sapiens/hg19/hg19.fa  hg19_mature.final.bed 

echo "Hairpin adittions with mature alignments" 

cd /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases
cp /scratch/aigutierrez/Tesis_Maestria/NCRNA_annotation/MIRNA_consensus/hg19_hairpin_complete.additions.bed .

#intersectBed  -loj -s -a hg19_hairpin_complete.additions.bed -b hg19_mature_bowtie.bed  | grep -Pv "\t-1\t" 

awk 'OFS="\t"{print $1,$2,$3,$4,$5,$6,"Additions",$7 }' hg19_hairpin_complete.additions.bed  > hg19_hairpin_complete.additions_cor.bed 

cat hg19_hairpin_complete.additions_cor.bed ../../Results/hg19_hairpin_complete.final.bed   > hg19_total_hairpins.bed

bash ../../Code/order_bed.sh hg19_total_hairpins.bed

mergeBed -i hg19_total_hairpins.bed -s -nms  -scores collapse | grep ","
