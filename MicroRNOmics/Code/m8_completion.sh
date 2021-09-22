for version in v20 v21
do
 {
	for type in hsa ort
	do
	{
 while read miR
 do
 mir=`echo $miR | awk '{print $1}'`
 ids=`echo $miR | awk '{print $2}'`
 length=`echo $miR | awk '{print $3}'`
 awk -v mir="$mir" -v ids="$ids" -v l="$length" -F'_' '{if ($1 == mir) print $0"\t"mir"\t"l"\t"ids }' \
 /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_"$type".out \
 >> /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Non_hsa_analysis/hg19_hairpin_"$version"_"$type".complete.out

 done < /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mirbase_seq/length_hairpin_"$version"_"$type".txt

	} & 
	done 
}& 
done 
wait 
