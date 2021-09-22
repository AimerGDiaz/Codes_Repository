# dir="" ;  mkdir $dir/Fastq $dir/Specific_Code $dir/Results $dir/Results/Statistics 2>/dev/null
# main_dir="/scr/hercules1san/aigutierrez/Total_Preprocessing/";run_dir="DENVpatients"; qsub -S /bin/bash -o "$main_dir"$run_dir/$run_dir.log -e "$main_dir"$run_dir/$run_dir.error -q normal.q@hercules6 Alignment.job $run_dir
#----------------------------------------Manual process of library downloading and name modification 
#----------------------------------------example codes 
#----------------------------------------Download_script.sh
#----------------------------------------Name modification and library organization  
#----------------------------------------Library_organization.sh 

#----------------------------------------Previous to start you need to have a dir with the following structure 
#----------------------------------------Treatment example 

##
#echo "Starting Quality analysis in $1"
#bash Quality_analysis.sh  "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/Fastq/" ".fastq" &  
#wait
#echo "Redundant reduction of $1 libraries"
#bash Redundant_reduction.sh  "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/" ".fastq" 6 
#echo "Starting  Quality analysis Reduction files of $1" 
#bash Quality_analysis.sh  "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/Fastq/" ".reduced.fastq" 
#
#wait 
#echo "Searching adapters in $1 libraries" 
#bash Adapter_finder.sh  "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/" 8 
#
#echo "Trimming adapters in $1 libraries with Trimmomatic and miR_Saver"
#bash F2Tab_Clipping.sh "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/" "_reduced_fastqtab.txt"  6 &  
#bash Trimmomatic.sh "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/" ".reduced.fastq" & 
#
#
#wait 
#echo "Starting  Quality analysis trimming files of $1"
#bash Quality_analysis.sh  "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/Fastq/" "_cor.fq" & 
#
########----------------------------------- Strategy cut adapters using trimmomatic 
#
#bash Quality_analysis.sh  "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/Fastq/" "_trim.fq"  & 
#
#wait 
#
#echo "Total Statistical analysis of $1 files and compressing fastq files"
#
#bash NGS_statistics.sh  "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/" & 
#
##### without cutting 
#for alinger in Bwa Bowtie Bowtie2 Segemehl 
#do
#	 
#		if [ "$alinger" == "Segemehl"  ]
#	        then
#		cores="10"
#		Rcores="6"
#		free_her="hercules6"
#	        else 
#		cores="5"
#		Rcores="7"
#		free_her=`for hercules in hercules2 hercules3 hercules4 hercules5  ; do echo -ne $hercules"\t"; ssh $hercules free  | awk 'NR==2{print $3}' ; done  | sort -h -k 2 |  awk 'NR==1{ print $1}'`
#		fi
# 
#	for type_of_al in "tmm"  "ms" "raw"
#	do
#main_dir="/scr/hercules1san/aigutierrez/Total_Preprocessing/"
#>"$main_dir"$1/Results/$1"_"$type_of_al"_"$alinger.log
#>"$main_dir"$1/Results/$1"_"$type_of_al"_"$alinger.error
#date  
# qsub -S /bin/bash -o "$main_dir"$1/Results/$1"_"$type_of_al"_"$alinger.log -e "$main_dir"$1/Results/$1"_"$type_of_al"_"$alinger.error -q  "normal.q@"$free_her -pe make $cores  Alingment_I_II.sh $1 $alinger $type_of_al $Rcores  "/scr/hercules1san/genomes/Homo_sapiens/hg19/hg19" 
#
#sleep 900
#	done
# 
#done


for tries in {1..200}
do
	if [ -f "$1"_TA.txt ]
	then	
       cat "$1"_TA.txt 
       echo "Compressing and extracting processing stats from $1 files" 
       bash Reads_reduction_statistics.sh "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/" & 
	break 
       rm "$1"_TA.txt
	else 
	sleep 600 
	echo waiting turn number $tries  
	fi                                                                                              
done 
## Generate name file epr each experiment - Challenge do it automatically 
##ls *_tmm.miRNA.bam   | perl -ne 'chomp $_;  $_=~s/([ac].*)_([mf].*)_(.*_.*)_tmm.*/$1$2$3/g; $sex=$1; $con=$2;$id=$3; $sex=~s/alzheimer/L/; $sex=~s/control/C/;$con=uc(substr($con,0,1)) ;  print  "$sex"."$con"."$id \t" ; ' > /scr/hercules1san/aigutierrez/Total_Preprocessing/Quantification_Statistics/head_alzheimer_sex.txt 


if [ "$1" == "Alzheimer_Col_R1" ] || [ "$1" == "Alzheimer_Col_R2" ]
then
name_file="head_alzheimer.txt"
Lib_rep="5 10 20 30"
Replicates="2 4 6"
Script="Alzheimer_simple.R"
elif [ "$1" == "Alzheimer_bib"  ]
then
name_file="head_alzheimer_sex.txt"
Lib_rep="5 10 20 30" 
Replicates="5 7 9 11"
Script="Alzheimer_sex.R"
fi

	for type_of_al in "tmm"  "ms" "raw"
	do 
	bash /scr/hercules1san/aigutierrez/Total_Preprocessing/Dir_generation.sh $1/DE_analysis_$type_of_al 
	done 

for alinger in Bwa Bowtie Bowtie2 Segemehl
do

        for type_of_al in "tmm"  "ms" "raw"
        do
	bash NGS_Bam_subsampling.sh "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/" $alinger $type_of_al
	bash /scr/hercules1san/aigutierrez/Total_Preprocessing/Quantification_Statistics/Run_counts_Mirna_simoultaniuosly.sh $1 $alinger $type_of_al $name_file  
	cd /scr/hercules1san/aigutierrez/Total_Preprocessing/$1/Results/$alinger/Bam/Unmapped/ 
	parallel --jobs 8 ' gzip {} ' :::*_"$type_of_al"_dr.fq & 
	done
done 	



  for DS in Mirbase_mirna Mirbase_hairpin #MIX MIRNA NCRNA 
  do
        for type_of_al in "tmm"  "ms" "raw"
        do                                 	

	cd /scr/hercules1san/aigutierrez/Total_Preprocessing/$1/DE_analysis"_"$type_of_al/
	echo -ne " Running statistical analysis for $DS with a significan level of 0.05 with the script  $Script , each gene must have more than  $Lib_rep \n and expresed in a set of $Replicates libraries \n"  
		for sig in "0.05" "0.1"
		do
	        bash Total_analysis.sh $DS $sig  $Script "$Lib_rep" "$Replicates" > /scr/hercules1san/aigutierrez/Total_Preprocessing/$1/DE_analysis"_"$type_of_al/Stats_"$DS"_"$sig".txt 
	# bash Total_analysis.sh Mirbase_hairpin 0.05 Alzheimer_simple.R "5 10 20 30" "2 4 6" 

		done 


	done 
  done
	
#########	ALINGERS STATISTICS 
echo Running Alingment statistics process 
bash Alingment_statistics.sh "/scr/hercules1san/aigutierrez/Total_Preprocessing/"$1"/" &


