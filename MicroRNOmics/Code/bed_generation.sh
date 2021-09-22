#cd /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/
#ls *.fa > fasta_list.txt 

##################    filter only hsa entries / correct names / calculate length per seq 

#for files in `cat fasta_list.txt` 
#do 
#echo "filtering hsa,  adjusting bioperl code  and extracting the raw length of $files" 
#{
#name=`basename -s ".fa" $files` 
#echo $name 
#perl /scr/hercules1san/aigutierrez/MicroRNOmics/Code/read_fasta_headers.pl $files hsa  $name"_hsa" 
#
#tr ' ' '_' < $files > "$name"_c.fa 
#
#perl /scr/hercules1san/aigutierrez/MicroRNOmics/Code/lengh_seq.pl "$name"_c.fa 
#} & 
#done  
#wait 
#

########### blast the sequence 


#ls hairpin_v*c.fa >  fasta_list.txt
# 
#for hairpin in `cat fasta_list.txt`
#do
#echo "blasting the hairpin $hairpin against hg19"  
#{ name1=`basename -s ".fa" $hairpin`  
#perl /scr/hercules1san/aigutierrez/MicroRNOmics/Code/blastall.pl $hairpin   
#} & 
#done  
#wait 
#rm fasta_list.txt 
#mv /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/*hsa.fa  /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis
#mv /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/*.out  /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/
##



#for version in v20 v21
#do
#echo "reducing the blast outoput of the version $version to < 10 mm and > 90% of query coverage" 
#{ 
#awk '{per=(($4*100)/$8);  if ($5 <= 10 && per >= 90 ) print $0"\t"per}' /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version".out > /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/temp_"$version" 
# 
# sort /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/temp_"$version"  |  uniq -u \
#  > /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_length.out 
# sort /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/temp_"$version"  |  uniq -d \
# >> /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_length.out 
# rm /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/temp_"$version"   
#
# grep Homo_sapiens /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_length.out > /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_hsa.out 
#
# grep -v Homo_sapiens /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_length.out > /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_ort.out
#
#} &
#done  
#wait 
#



#for version in v20 v21
#do
#{ 
#echo "reducing the mir to search in the length file $version" 
#
#	for types in hsa ort
#	do 
#	echo "in the file type $types" 
#  	{
#	  for f in `cut -f 1  /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_"$types".out | cut -d '_' -f 1  | sort | uniq `
#	  do
# 	  grep -w $f /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/length_hairpin_"$version"_c.txt >> /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/temp_length_"$version"_"$types".txt 
#	  done 
#
#        sort /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/temp_length_"$version"_"$types".txt | uniq -u \
# 	> /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/length_hairpin_"$version"_"$types".txt 
#	sort /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/temp_length_"$version"_"$types".txt | uniq -d \
#        >> /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/length_hairpin_"$version"_"$types".txt
#	rm /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/temp_length_"$version"_"$types".txt 
#	} & 
#	done
#	wait  
#		 
#
# }&
#done
#wait 
# 




# 
#for version in v20 v21
#do 
#echo "mapping the real query $version length to the blast output" 
# {
#	for types in hsa ort
#	do 
# 	{
#	echo $types 
#	 while read miR
# do
# mir=`echo $miR | awk '{print $1}'`
# ids=`echo $miR | awk '{print $2}'`
# length=`echo $miR | awk '{print $3}'`
# awk -v mir="$mir" -v ids="$ids" -v l="$length" -F'_' '{if ($1 == mir) print $0"\t"mir"\t"l"\t"ids }' /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_"$types".out >>  /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_"$types".full.out
#done < /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/length_hairpin_"$version"_"$types".txt
#
# perl /scr/hercules1san/aigutierrez/MicroRNOmics/Code/blast_m8_2bed.pl  /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_"$types".full.out
#	} &
#      ##cd /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis 
#	done
#	wait 
#}& 
#done 
#wait 



# mkdir /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/Temp_files/   2>/dev/null
# mv /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/*ort* /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/
# mv /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/*hsa* /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis/
# mv  /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/*_c.*   /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/Temp_files/ 
# mv /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/*hsa*   /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis/ 



#
# for dir in Non_hsa_analysis Hsa_analysis 
# do
#{
# echo "merging and intersecting the coordinates in $dir" 
# mkdir  /scr/hercules1san/aigutierrez/MicroRNOmics/Data/$dir/Temp_files/  2>/dev/null 
# mv /scr/hercules1san/aigutierrez/MicroRNOmics/Data/$dir/*.[ot]* /scr/hercules1san/aigutierrez/MicroRNOmics/Data/$dir/Temp_files/
# 
# cd /scr/hercules1san/aigutierrez/MicroRNOmics/Data/$dir 
#	if [ "$dir" = "Non_hsa_analysis" ] 
#	then 
#	bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/mix_bed_general.sh  hg19_hairpin_v20_ort.exact.bed hg19_hairpin_v21_ort.exact.bed hg19_hairpin_ort_mix Nhsa 
#	  for f  in hg19_hairpin_v20_ort.lookalike.bed hg19_hairpin_v21_ort.lookalike.bed
#	  do
#	  bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/lookalikes_detection.sh $f
#	  done
#        bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/mix_bed_general.sh  hg19_hairpin_v20_ort.lookalike.cor.bed hg19_hairpin_v21_ort.lookalike.cor.bed   hg19_hairpin_mix_ort.lk LK
#
#    	intersectBed -s -v   -b hg19_hairpin_ort_mix.bed -a hg19_hairpin_mix_ort.lk.bed  > temp_add
#
#	cat hg19_hairpin_ort_mix.bed temp_add  > hg19_hairpin_ort_mix_lk.total.bed
#
# 	rm temp_add 
#	mv *lookalike*  ../Lookalikes/
#	bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/order_bed.sh hg19_hairpin_ort_mix_lk.total.bed	
#
#	elif [ "$dir" = "Hsa_analysis" ] 
#	then 
#	bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/mix_bed_general.sh hg19_hairpin_v20_hsa.exact.bed hg19_hairpin_v21_hsa.exact.bed hg19_hairpin_mix_hsa hsa
#	  for f  in hg19_hairpin_v20_hsa.lookalike.bed hg19_hairpin_v21_hsa.lookalike.bed
#   	  do
#	  bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/lookalikes_detection.sh $f
#	  done
#        bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/mix_bed_general.sh  hg19_hairpin_v20_hsa.lookalike.cor.bed hg19_hairpin_v21_hsa.lookalike.cor.bed hg19_hairpin_mix_hsa.lk LK_hsa
#	intersectBed -s -v   -b hg19_hairpin_mix_hsa.bed -a hg19_hairpin_mix_hsa.lk.bed  > temp_add	
#       	cat hg19_hairpin_mix_hsa.bed temp_add  > hg19_hairpin_mix_hsa_lk.total.bed
#       	rm temp_add 
#	mv *lookalike*  ../Lookalikes/
#       	bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/order_bed.sh hg19_hairpin_mix_hsa_lk.total.bed
#	fi 
#}& 
#done  
#wait 

echo "Generating the mix bed nohsa_lk with hsa_lk"
	
  intersectBed -s -v  -a /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_ort_mix_lk.total.bed -b /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis/hg19_hairpin_mix_hsa_lk.total.bed  >  /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_nhsa_final.bed 
#
  cat /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_nhsa_final.bed /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis/hg19_hairpin_mix_hsa_lk.total.bed > /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.bed 

#test sort  /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis/hg19_hairpin_mix_hsa_lk.total.bed /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_nhsa_final.bed  /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.bed | uniq -u

echo "Keeping the old names into account"  
  cd /scr/hercules1san/aigutierrez/MicroRNOmics/Results/
  egrep  "\-lk|hsaP" /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.bed  | cut -f 2-4,7  > /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/changed_names.txt 
#
  bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/equivalence_name.sh 

  rm /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.*.fa* /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.real_prlg.bed 2>/dev/null
#
echo "Extractin the hairpin fasta file and reducing identical sequences" 
  perl /scr/hercules1san/aigutierrez/MicroRNOmics/Code/hsa_mir_extraction.pl /scr/hercules1san/genomes/Homo_sapiens/hg19/hg19.fa /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.bed >/dev/null
#
  perl /scr/hercules1san/aigutierrez/MicroRNOmics/Code/filter_fasta_prlgs_uniqs.pl /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.hairpin_loci.fasta
#  
echo "Correcting the names to discrimiante real prlgs" 
  bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/order_bed.sh /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.real_prlg.bed 
  bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/order_bed.sh /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.bed
  rm /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.hairpin_loci.fasta # *.bed 
#
 paste -d'\t' /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.bed /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.real_prlg.bed  | awk '{print $1"\t"$2"\t"$3"\t"$12"\t"$5"\t"$6"\t"$7"\t"$8}' > /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.real_prlg2.bed
   mv /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.real_prlg2.bed /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.real_prlg.bed
 bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/order_bed.sh  /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.real_prlg.bed 

echo "Extracting nested sequences and filtering to a single name " 
 blastclust -i /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.hairpin_loci_uq.fa   -p F -L .95 -b F -S 100 -W 10  | awk '{gsub(" h","_h",$0)}{print $0}'  |  grep  "_"    > /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin.clus

 cd /scr/hercules1san/aigutierrez/MicroRNOmics/Code
# bash test_cluster_identity_massive.sh  /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin.clus  
  bash test_cluster_identity_massive.sh hg19_hairpin_complete /scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin.clus 
 
 cd /scr/hercules1san/aigutierrez/MicroRNOmics/Results
#  awk -F' ' '{print $1}' hg19_hairpin_complete.pos_clus.txt | awk -F'-' '{print $1"-"$2"-"$3"-clus"}'  > b
#  paste b hg19_hairpin_complete.pos_clus.txt > hg19_hairpin.cor.clus ; rm b 
 
   awk -F' ' '{print $1}' hg19_hairpin_complete.clus.txt | awk -F'-' '{print $1"-"$2"-"$3"-clus"}'  > b 
   paste b hg19_hairpin_complete.clus.txt > hg19_hairpin.cor.clus ; rm b
echo "Repalcing the raw names per cluster names"  
  perl /scr/hercules1san/aigutierrez/MicroRNOmics/Code/Bed_prlg_name.pl hg19_hairpin.cor.clus hg19_hairpin_complete.real_prlg.bed

 #  mergeBed -i hg19_hairpin_complete.real_prlg.clus.bed -s -nms  -scores mean   -d -10 | grep ";"   | awk '{print $4}'  | tr ';' '\n'  | sort  | uniq  > overlapping_features.txt
echo "Mixing coordinates with 5 nucleotides overhanging " 
   bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/order_bed.sh  hg19_hairpin_complete.real_prlg.clus.bed  
   mergeBed -i hg19_hairpin_complete.real_prlg.clus.bed -s -nms  -scores mean   -d -5  | grep ";"   > a.bed  # test the overlapping umbral with -d -10 saving to b.bed thens ort and uniq 
   intersectBed  -v -s -a hg19_hairpin_complete.real_prlg.clus.bed -b a.bed  > clean_over.bed 
   awk 'OFS="\t"{first=$4; second=$4; gsub(";.*","",first); gsub(".*;","",second); if (first != second) first=first";"second; print $1,$2,$3, first, $5, $6 , "MI-OVERLAP", ($3-$2)  }' a.bed  > a.cor.bed
   cat clean_over.bed  a.cor.bed   > hg19_hairpin_complete.final.bed ; rm a.bed  clean_over.bed a.cor.bed 
    bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/order_bed.sh  hg19_hairpin_complete.final.bed    
   mergeBed -i hg19_hairpin_complete.final.bed -s -nms  -scores mean   -d -10 | grep ";"     > hg19_hairpin_complete.overlapping.bed 


echo "Extracting the  set of uniq hairping fasta " 

   cut -f 4 hg19_hairpin_complete.final.bed | sort | uniq  -d > greater
   cut -f 4 hg19_hairpin_complete.final.bed | sort | uniq  -u > single 

   for f  in `cat  greater` ; do grep -P "$f\t"  hg19_hairpin_complete.final.bed | sort -k 6n | head -n +1 ; done  >  hg19_hairpin_complete.temp_highly_rep.bed 
   for f  in `cat  single` ; do grep -P "$f\t"  hg19_hairpin_complete.final.bed  ; done  >>  hg19_hairpin_complete.temp_highly_rep.bed ; rm greater single 
#rm *.fa   *.fasta 2>/dev/null
    cut -f 2 hg19_hairpin_complete.temp_highly_rep.bed | sort | uniq -d  > rare ; grep -f rare hg19_hairpin_complete.temp_highly_rep.bed > mismatch_prlgs.bed ; rm rare

#perl /scr/hercules1san/aigutierrez/MicroRNOmics/Code/hsa_mir_extraction.pl /scr/hercules1san/genomes/Homo_sapiens/hg19/hg19.fa hg19_hairpin_complete.temp_highly_rep.bed 
perl /scr/hercules1san/aigutierrez/MicroRNOmics/Code/hsa_mir_extraction.pl  /scr/hercules1san/genomes/Homo_sapiens/hg19/hg19.fa hg19_hairpin_complete.final.bed

   bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/order_bed.sh  hg19_hairpin_complete.final.bed 

   bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/mature_mix_generation.sh


