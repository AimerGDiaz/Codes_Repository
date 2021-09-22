# bash Hepatitis/DE_analysis
#for kind in _tmm 
mkdir $1/Rscript 2>/dev/null 
for f  in MIRNA NCRNA MIX Mirbase_mirna Mirbase_hairpin
 do
 mkdir $1/$f 2>/dev/null
  mkdir $1/$f/Mapping 2>/dev/null
  mkdir $1/$f/Candidates  2>/dev/null
  mkdir $1/$f/Final 2>/dev/null
  mkdir $1/$f/Mapping/Statistics 2>/dev/null

	 for g in  Segemehl Bowtie Bowtie2 BWA
	 do
	 mkdir $1/$f/Mapping/$g 2>/dev/null
	 mkdir  $1/$f/Mapping/$g/Data $1/$f/Mapping/$g/Results  $1/$f/Mapping/$g/Results/Smear 2>/dev/null
	  done 
 done

cd /scr/hercules1san/aigutierrez/Total_Preprocessing/Quantification_Statistics/DE_codes/ 

cp Total_analysis.sh Transpose.awk Post_statistical_analysis.sh Extract_top_miRs*.sh remove_all_results.sh Heat_map_auto.R /scr/hercules1san/aigutierrez/Total_Preprocessing/$1/
#cp hist1.R  Statistical_analysis.sh /scr/hercules1san/aigutierrez/Total_Preprocessing/$1/Rscript/
cp -r Rscript /scr/hercules1san/aigutierrez/Total_Preprocessing/$1/

