#bash test_cluster.sh `echo hsa-mir-4436b-1_hsa-mir-4436b-2 | awk -F'_'  '{for(i=1;i<=NF;i++){printf "%s\n", $i}}'` 

#bash test_cluster.sh `grep hsa-mir-1302 hg19_hairpin_v20.o.bed  | cut -f 4 | sort | uniq` 
#bash test_cluster.sh mature_mix $mir

#test from mature mped to hairpin 
#bash test_cluster.sh `grep chrX_16645135_16645208_hsa-mir-548am_MI0016904_- Hsa_restricted/Mature/hg19_hairpin_mature_v21.out.coincidence   | cut -f 4 | tr '\n' ' '`
database=`echo $1`

total=("${@:2}")
 for m in "${total[@]}"
 do 


if [ "$database" = "mature_mix" ] 
 then
file="/scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases/mature_mix.uqcor.fa" 
elif [ "$database" = "hg19_hairpin_complete" ]
 then  
#else
file="/scr/hercules1san/aigutierrez/MicroRNOmics/Results/hg19_hairpin_complete.hairpin_loci_uq.fa"
fi 

awk ' /'$m'$/{hea=$0}; /'$m'$/ {flag=1;next} /^>/{flag=0} flag {print hea"\n"$0} ' < `echo $file` 
	
 done  >cluster_tested.fasta 


Per=`clustalw2  -infile=cluster_tested.fasta | awk '/Aligned. Score:/{printf $5" "}' ` 
Length=`clustalw2  -infile=cluster_tested.fasta  |  awk '/^Sequence.*bp/{printf $4" "$5" "}'`
 
echo -ne "${total[@]}\t$Per\t$Length\t+\n" >> $database.clusters_statistcs.txt 
echo -en "\t\t\t\t The percentage score of matcing is $Per\t\t\t\n" 

rm cluster_tested.fasta 
rm cluster_tested.dnd
cat cluster_tested.aln
#lose the conservation information (*)
grep '^hsa' cluster_tested.aln > cluster_tested_2.aln
echo 
perl clustalw_oneline.pl cluster_tested_2.aln
#conserved=`grep -o "*" cluster_tested.aln |  wc | awk '{print $1}'`

#echo "
#		$conserved Conserved positions" 
#echo "
#  Not conserved position"
#grep -m1  "*" cluster_tested.aln | grep -ob  "*" |  awk -F':' '{print ($1 - 20)}' | awk '($1 != p + 1) {print p + 1 " - " $1} {p = $1}' 
#grep -m2  "*" cluster_tested.aln | tail -n +2  |  grep -ob  "*" |  awk -F':' '{print (($1 - 20)+60)}' | awk '($1 != p + 1) {print p + 1 " - " $1} {p = $1} ' | tail -n +2
echo
#rm cluster_tested.aln cluster_tested_2.aln


#total=${#seq[*]}
#for (( i=1; i<=$(( $total -1 )); i++ ))
#do
#seq2+=(${seq[i]})
#done
#echo ${seq[@]}
#echo ${seq2[@]}

