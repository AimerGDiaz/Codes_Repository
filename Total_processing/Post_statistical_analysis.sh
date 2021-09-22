#In Final Dir 

	for f in $1/Mapping/*/Results/*/Smear/*final.txt
	do 
	dir=`echo $f | cut -d'/' -f 1-6  `
	trans=`basename -s ".txt" $f`
	awk -f Transpose.awk $f >  $dir/$trans"_T.txt" 
	done
	
	for f in $1/Mapping/[BS]*/Results/*/Smear/*_final_T.txt
	do
	alig=`echo $f | cut -d'/' -f 3`
	treat=`echo $f | cut -d'/' -f 5`
	#5_Lib_6
	name=`basename -s ".txt" $f | cut -d'_' -f 1 | awk -F 'Segemehl|Bowtie|Bowtie2|BWA' '{print $1}'`
	mkdir $1/Final/$treat 2>/dev/null
#	header=`awk 'NR==1{print "Method\t"$0}' $f  | tr -d '"'`
	awk -v name="$name" 'NR>=2{print name"\t"$0}' $f  | tr -d '"'   >> $1/Final/$treat/$treat"_"$alig"_"total.txt
	done 
#DENVmi_clean_5_24.txt
	for  f in  $1/Mapping/*/Data/DENVmi_clean_[0-9]*.txt
	do
	treat=`basename -s ".txt" $f | awk -F'_' '{print $3"_Lib_"$4}'`
	name=`basename $f`
	ali=`echo $f | cut -d'/' -f 3`
	cp $f $1/Final/$treat/$ali"_"$name
	done 

	for f  in $2 
	do
	head -n +1  $1/Mapping/Statistics/Size_variable_"$f"_12.txt  | \
 	awk '{$1="Inital_size"; print $1"\t"$2"\t"$3"\t"$4}'  > $1/Mapping/Statistics/Size_variable_"$f"_filter.txt \
	&& cat $1/Mapping/Statistics/Size_variable_"$f"_*.txt  | grep -v Pre_filter  | sort  -k 4n  >> $1/Mapping/Statistics/Size_variable_"$f"_filter.txt 
	done 
	rm $1/Mapping/Statistics/Size_variable_*_[0-9]*.txt 

	for f  in Bowtie Bowtie2  Segemehl BWA
	do
	paste $1/Mapping/$f/Data/miRs_filter_5.txt $1/Mapping/$f/Data/miRs_filter_10.txt  $1/Mapping/$f/Data/miRs_filter_20.txt $1/Mapping/$f/Data/miRs_filter_30.txt \
	$1/Mapping/$f/Data/miRs_filter_40.txt $1/Mapping/$f/Data/miRs_filter_50.txt| awk 'NR>1{print $1"\t"$2"\t"$4"\t"$6"\t"$8"\t"$10"\t"$12}'  > $1/Mapping/Statistics/"$f"_miRs_filters.txt
	sed -i '1s/^/No_Lib\tF5\tF10\tF20\tF30\n/' $1/Mapping/Statistics/"$f"_miRs_filters.txt
	done


	

