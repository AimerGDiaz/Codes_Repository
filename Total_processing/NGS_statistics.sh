#!/bin/bash

###################################################################################################################################
# Extract quality information of DENV_RNA libraries
# make names generalized 

cd $1"Fastq/Quality"
> $1"Results/Statistics/Length_distribution.txt"
> $1"Results/Statistics/Total_size.txt"
> $1"Results/Statistics/Quality_base.txt" 
ls -d *_fastqc > dir_list.txt 
	while read library
	do 
	FILE="$1"/Fastq/Quality/$library/fastqc_data.txt
#	name=`echo $library | awk -v RS='\r' -F '_|\\\.' '{print $1"_"$2}'`
#	type_file=`echo $library | awk -v RS='\r' -F '\\\.|_' '{print $3"_"$4}'`
	type_file=`echo $library | egrep -o  "_fastqc|_reduced_cor_fastqc|.reduced_fastqc|_trim_fastqc"`
	name=`echo $library | awk -v sus="$type_file"  '{gsub(sus,"",$0);print $0}'`
	if [ "$type_file" == "_fastqc" ] 
	then 
	lib_type="raw"	
	elif [ "$type_file" == "_reduced_cor_fastqc" ] 
	then 
	lib_type="ms_reduced"
	elif [ "$type_file" == ".reduced_fastqc" ]
	then
	lib_type="reduced"
	elif [ "$type_file" == "_trim_fastqc" ]
	then	
	lib_type="tmm_reduced"
	fi

#	echo $lib_type 
        awk '/^Total Sequences/{ts=$3}  /^Sequence length/{print "'$name'" "\t" "'$lib_type'" "\t" $3 "\t" ts}' $FILE	>> $1"Results/Statistics/Total_size.txt"
#	
#	#	Library Total.Sequences Sequence.length
# #       Split Length distribution
	awk '/Length[[:space:]]Count/ {flag=1;next} /^>>END_MODULE/{flag=0} flag {num=sprintf("%.0f",$2);print "'$name'" "\t" "'$lib_type'" "\t"$1"\t"num}' $FILE >> $1"Results/Statistics/Length_distribution.txt"
#	 #Split Queality per base
	awk '/#Base\tMean\tMedian/ {flag=1;next} /^>>END_MODULE/{flag=0} flag {print "'$name'" "\t" "'$lib_type'" "\t" $0 }' $FILE >>  $1"Results/Statistics/Quality_base.txt"
#        #Split Per sequence GC
#   #     awk '/#GC[[:space:]]Content/ {flag=1;next} /^>>END_MODULE/{flag=0} flag {print "'$NAME'" "\t" $0}' $f >> /scratchsan/aigutierrez/Results/Statistics/Raw_Procol/$ResultsDir/GC_Seq.txt
       done < dir_list.txt
		


		#Column Names
		#Total_Seq
		 sed -i '1s/^/Library\tProcedure\tS_Length\tTolta_Seq\n/'  "$1"Results/Statistics/Total_size.txt
#		#Length_distribution
		 sed -i '1s/^/Library\tProcedure\tLength_range\tReads_N\n/' "$1"Results/Statistics/Length_distribution.txt  
#		#Qualty per Base
		 sed -i '1s/^/Library\tProcedure\tN_Base\tMean\tMedian\tL_Quartile\tU_Quartile\t10th%\t90th%\n/'  "$1"Results/Statistics/Quality_base.txt
#		#Per Seq GC
		# sed -i '1s/^/Library\tGC%\tSeq_Content\n/'  ../../Results/Statistics/InitialProc/DENV_patient_GCpbase_raw.txt
		
#miRNA echo "12d4_S7_fastqc" | cut -d_ -f 1
#Patients echo DWOS13-12.R1_fastqc/ | cut -d- -f 1

