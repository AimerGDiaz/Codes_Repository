#while read clus; do   mir=`echo $clus | awk 'gsub("_"," ",$2) {print $2}'  `; bash test_cluster.sh hairpin_v21 $mir ; done < ../Data/Mirbase_Seq/B_clust/hairpin_v21.hsa.Ti.clus; awk -F'\t' '{if ($2 < 100) print}' < hairpin_v21.clusters_statistcs.txt  > hairpin_v21.negative_clusters.txt; bash test_cluster_negative_sense.sh hairpin_v21 hairpin_v21.negative_clusters.txt

#while read clus; do   mir=`echo $clus | awk 'gsub("_"," ",$2) {print $2}'  `; bash test_cluster.sh mature_mix $mir ; done < ../Data/Mature_to_Hairpin/mature.mix.clus; awk -F'\t' '{if ($2 < 100) print}' < mature_mix.clusters_statistcs.txt  > mature_mix.negative_clusters.txt; bash test_cluster_negative_sense.sh mature_mix mature_mix.negative_clusters.txt

#while read L ; do;  if [[ $L == ">"* ]]; then; echo "$L" > b.fa; else echo $L | rev | tr "AUGCaugc" "UACGuacg" >> b.fa; fi; done < a.fa
database=`echo $1`
 
 while read clus

 do  

if [ "$database" = "mature_mix" ]
then 
Seqs="/scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases/mature_mix.uqcor.fa"
elif [ "$database" = "hg19_hairpin_complete" ]
#else 
 then
Seqs="/scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.hairpin_loci_uq.fa"
fi

 n_mir=`echo $clus | awk -F' ' ' {print $2 }'` 
 p_mir=`echo $clus | awk -F' ' ' {print $1 }'` 
 awk ' /'$p_mir'$/; /'$p_mir'$/ {flag=1;next} /^>/{flag=0} flag {gsub("\n",""); print $0 } ' < `echo $Seqs` > a.fa   
	 while read L
	 do
	 if [[ $L == ">"* ]]
	 then
	 echo "$L" > b.fa	
#	 else echo $L | rev | tr "AUGCaugc" "UACGuacg" >> b.fa 
	 else echo $L | rev | tr "ATGCaugc" "TACGtacg" >> b.fa
	 fi
	 done < a.fa 
	 rm a.fa 
	 awk ' /'$n_mir'$/; /'$n_mir'$/ {flag=1;next} /^>/{flag=0} flag {gsub("\n",""); print $0 } ' < `echo $Seqs` >> b.fa
Per=`clustalw2  -infile=b.fa  | awk '/Aligned. Score:/{printf $5" "}'` 
Length=`clustalw2  -infile=b.fa |  awk '/^Sequence.*bp/{printf $4" "$5" "}'` 
echo -ne "$p_mir $n_mir\t$Per\t$Length\t-\n" >> $database.clusters_statistcs.txt
#echo -en "\t\t\t\t The percentage score of matcing is $Per\t\t\t\n"
#	cat b.aln 
echo -ne "__________________________________________\n\t\t\t\t\t\t\tTesting with the last seq in negative sense\n"
	
cat b.aln	
grep '^hsa' b.aln > b_2.aln
echo 
perl clustalw_oneline.pl b_2.aln
echo
	rm b.aln b.dnd b.fa b_2.aln

 done <  $2
sort  $database.clusters_statistcs.txt  > a; mv a $database.clusters_statistcs.txt
cat $database.clusters_statistcs.txt
