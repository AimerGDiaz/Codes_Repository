echo " extract the list of uniq coordinates" 
cut -f 1-3 $1 $2 | sort | uniq -u   > temp_file1_"$3".list 
echo " save duplicates files "
cut -f 1-3 $1 $2 | sort | uniq -d  > temp_file2_"$3".list

echo "extract the entire lines of uniq coordinates" 
for list in 1 2 
do
{
 while read miR
 do
 chr=`echo $miR | awk '{print $1}'`
 start=`echo $miR | awk '{print $2}'`
 end=`echo $miR | awk '{print $3}'`
 awk -v chr="$chr" -v start="$start" -v end="$end" '{if ($1 == chr && $2 == start && $3 == end) print $0 }' $1 $2
 done < temp_file"$list"_"$3".list > temp_file"$list"_"$3".bed
} & 
done
wait  


	if [ "$4" = "Nhsa" ] 
	then
#reduce the overlapping inside uniq coordiantes of eache file   
 intersectBed -s -f 1 -b temp_file2_"$3".bed -a temp_file1_"$3".bed  > temp_file3_"$3".bed
 intersectBed -v -s -b temp_file2_"$3".bed -a temp_file1_"$3".bed  > temp_file3a_"$3".bed
 
#mix uniq files with duplicates 
 cat temp_file2_"$3".bed temp_file3_"$3".bed  temp_file3a_"$3".bed >  temp_file4_"$3".bed

 perl -ne ' chomp $_; @colums = split /\t/, $_; $colums[3]=~ s/.*(-(mir|let)-[0-9]+)-?.*/$1/; $colums[3]="hsaP".$colums[3]; $colums[6]="MI-NHSA"; foreach $i (@colums) {print $i."\t"}; print "\n";' temp_file4_"$3".bed | sort | uniq > "$3".bed

	elif [ "$4" = "LK" ]
 	then

 intersectBed -s -v -b temp_file2_"$3".bed -a temp_file1_"$3".bed  > temp_file3_"$3".bed
 intersectBed -v -s -b temp_file2_"$3".bed -a temp_file1_"$3".bed  > temp_file3a_"$3".bed

 cat temp_file2_"$3".bed temp_file3_"$3".bed  temp_file3a_"$3".bed >  temp_file4_"$3".bed

 perl -ne ' chomp $_; @colums = split /\t/, $_; $colums[3]=~ s/.*(-(mir|let)-[0-9]+)-?.*/$1/; $colums[3]="hsaP".$colums[3]."-lk";  foreach $i (@colums) {    print $i."\t"}; print "\n";' temp_file4_"$3".bed   | sort | uniq > "$3".bed

	elif [ "$4" = "hsa" ]
	then

 intersectBed -s -f 1 -b temp_file2_"$3".bed -a temp_file1_"$3".bed  > temp_file3_"$3".bed
 intersectBed -v -s -b temp_file2_"$3".bed -a temp_file1_"$3".bed  > temp_file3a_"$3".bed
 cat temp_file2_"$3".bed temp_file3_"$3".bed temp_file3a_"$3".bed |sort | uniq >  temp_file4_"$3".bed
 
	cut -f 1-3 temp_file4_"$3".bed | sort | uniq -d  > temp_file5_"$3".list
        cut -f 1-3 temp_file4_"$3".bed | sort | uniq -u  > temp_file6_"$3".list

		for list in 5 6 
		do
		{
		while read miR
		do 
		chr=`echo $miR | awk '{print $1}'`
		start=`echo $miR | awk '{print $2}'`
		end=`echo $miR | awk '{print $3}'`
		awk -v chr="$chr" -v start="$start" -v end="$end" '{if ($1 == chr && $2 == start && $3 == end) print $0 }' temp_file4_"$3".bed
		done < temp_file"$list"_"$3".list  >  temp_file"$list"_"$3".bed
		}& 
		done
		wait  
	
#	perl -ne ' chomp $_; @colums = split /\t/, $_; $colums[3]=~ s/(.*-(mir|let)-[0-9]+)([a-z]|-)/$1-r/; $colums[6]="MI_Redundancy"; foreach $i (@colums) {print $i."\t"}; print "\n";' temp_file5_"$3".bed | sort | uniq > temp_file7_"$3".bed 
	perl -ne ' chomp $_; @colums = split /\t/, $_; $colums[3]=~ s/(.*(mir|let)-[0-9]+)([a-z]|-)?.*/$1-r/; $colums[6]="MI-Redundancy"; foreach $i (@colums) {print $i."\t"}; print "\n";' temp_file5_"$3".bed | sort | uniq > temp_file7_"$3".bed 
#	sort  temp_file7_"$3".bed  temp_file4_"$3".bed | uniq -u  > temp_file7_"$3".bed 
	
	cat temp_file6_"$3".bed temp_file7_"$3".bed > $3.bed 

	elif [ "$4" = "LK_hsa" ]
	then                 
	
	intersectBed -s -v -b temp_file2_"$3".bed -a temp_file1_"$3".bed  > temp_file3_"$3".bed
         intersectBed -v -s -b temp_file2_"$3".bed -a temp_file1_"$3".bed  > temp_file3a_"$3".bed
        cat temp_file2_"$3".bed temp_file3_"$3".bed  temp_file3a_"$3".bed >  temp_file4_"$3".bed
	
	perl -ne ' chomp $_; @colums = split /\t/, $_; $colums[3]=~ s/(.*(mir|let)-[0-9]+)([a-z]|-)?.*/$1-lk/;  foreach $i (@colums) {print $i."\t"}; print "\n";' temp_file4_"$3".bed | sort | uniq > "$3".bed 	
	fi
 
	bash /scr/hercules1san/aigutierrez/MicroRNOmics/Code/order_bed.sh $3.bed
	rm temp*
#test 
#intersectBed -v -s -b  hg19_hairpin_mix_hsa.bed -a hg19_hairpin_v20_hsa.exact.bed 
#intersectBed -v -s -b  hg19_hairpin_mix_hsa.bed -a hg19_hairpin_v21_hsa.exact.bed
#cut -f 1-3 hg19_hairpin_mix_hsa.bed  | sort | uniq -d  > check
#for f  in `cut -f 2 check`; do grep -w $f hg19_hairpin_mix_hsa.bed; done 

