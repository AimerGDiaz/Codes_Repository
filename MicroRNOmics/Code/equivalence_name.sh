
#MI_MajorLK
#MI_MinorLK
#MI_NHSA

 while read miR
 do
 start_c=`echo $miR | awk '{print $1}'`
 end=`echo $miR | awk '{print $2}'`
 mir=`echo $miR | awk '{print $3}'`
 
	class=`echo $mir | awk -F'-' '{print $1}'` 

 file=`echo $miR | awk '{print $4}'`

	if [ "$file" != "MI-NHSA" ]
 	then
		if [ "$class" = "hsa" ] 
		then 
	original_name=/scr/hercules1san/aigutierrez/MicroRNOmics/Data/Lookalikes/hg19_hairpin_v2[01]_hsa.lookalike.cor.bed
		elif [ "$class" = "hsaP" ] 
		then
        original_name=/scr/hercules1san/aigutierrez/MicroRNOmics/Data/Lookalikes/hg19_hairpin_v2[01]_ort.lookalike.cor.bed
		fi

	elif [  "$file" = "MI-NHSA" ] 
	then 
        original_name=/scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_v2[01]_ort.exact.bed
	fi

	awk -v start="$start_c" -v end="$end" -v mir="$mir" '{if ($2 == start && $3 == end ) print mir"_"$2"_"$3"\t"$4"\t" }' $original_name  | head -n +1 
#	 echo 
#124506394	124506443	hsa-mir-7641-lk	MI_MinorLK
 done < /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/changed_names.txt > /scr/hercules1san/aigutierrez/MicroRNOmics/Results/names_equivalence.txt 

