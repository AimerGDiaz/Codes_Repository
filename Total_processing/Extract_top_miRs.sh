######  Unified the statistics in only one table
mkdir $1/Candidates/Total_statistics_raw 
mv $1/Candidates/Total_raw_statiscs* $1/Candidates/Total_statistics_raw 
cd $1/Candidates/
p_val=$2
mkdir Significance_"$p_val" 
	for f  in Total_statistics_raw/Total_raw_statiscs_*_Lib_*contrast.txt  
	do
	final=`basename -s ".txt" $f | cut -d'_' -f 4-6`
# echo -ne ----------------$final--------------; wc $f | awk '{print "Total entires",$1}' 
	awk -v lib="$final" -v pval="$p_val" '{if ($3 ~ /.*D.*M.*/ && ($5 >= 0.585 || $5 <= -0.585 ) && $6 > 5 &&  $8<=0.05 && $9<=pval ) print lib"\t"$0}' $f
	done >Total_raw_statiscs_Top_only_contrast.txt

#        for f  in Total_raw_statiscs_*_Lib_*contrast.txt; do final=`basename -s ".txt" $f | cut -d'_' -f 4-6`; grep -wf DENV_miR_reported.txt $f | awk -v lib="$final" '{if ($3 ~ /.*D.*M.*/ && $9<=0.1) print lib"\t"$0}'; done  



#### Extract the top miRs DE
	for f  in Total_statistics_raw/Total_raw_statiscs_*_Lib_*contrast.txt  
	do
	awk -v lib="$final" -v pval="$p_val"  '{if ($3 ~ /.*D.*M.*/ && ($5 >= 0.585 || $5 <= -0.585 )  && $6 >5 && $8<=0.05 && $9<=pval ) print}' $f 
	done |  cut -f 4 | sort | uniq  > Significance_"$p_val"/miRs_top_all_analysis.txt


####  Extract the best statistics per treatment / per constrast 

for f  in `cat  Significance_"$p_val"/miRs_top_all_analysis.txt `
do 
	for contrast in 13_D03vsM03 14_D12vsM12 15_D24vsM24 16_D48vsM48 17_D12vsD03vsM12vsM03 18_D24vsD12vsM24vsM12 19_D48vsD24vsM48vsM24 \
20_D24vsD03vsM24vsM03 21_D48vsD03vsM48vsM03 22_D48vsD12vsM48vsM12 
	do 
	grep -w $f  Total_raw_statiscs_Top_only_contrast.txt |\
	awk -v cont="$contrast" -v pval="$p_val" '{if ($4 == cont &&  ($6 >= 0.585 || $6 <= -0.585 ) && $7 > 5  && $9<=0.05 && $10<=pval) print}' |\
	 sort  -r -k 10g | head -n +1
	done 
done > Significance_"$p_val"/Top_miRs_best_score.txt


#### Avoid mIRs counts redundancy
for f in `cat Significance_"$p_val"/miRs_top_all_analysis.txt`
do
grep -w  $f Significance_"$p_val"/Top_miRs_best_score.txt | sort -r -k 10g | head -n +1 
done >  Significance_"$p_val"/Top_miRs_best_score_uq.txt 
#for f in `cat miRs_top_all_analysis.txt`; do grep  $f Top_miRs_best_score.txt | sort -r -k 10g | head -n +1; done >  Top_miRs_best_score_uq.txt

####  Extract better counts
while read top
do 
ali=`echo $top | awk '{print $2}' `
lib=`echo $top | awk '{print $1}'`
met=`echo $top | awk '{print $3}'`
mir=`echo $top | awk '{gsub(/.*\\|/,"",$5); gsub("-","_",$5);print $5}'`
# echo  $lib $ali $met $mir
grep -wP "$met\t.*$mir" ../Final/$lib/$lib"_"$ali"_total.txt"
done < Significance_"$p_val"/Top_miRs_best_score_uq.txt > Significance_"$p_val"/Top_miRs_best_counts.txt

#head -n +1 ../Final/40_Lib_6/BWA_DENVmi_clean_40_6.txt  > Top_miRs_best_counts_corrected.txt
cp ../../Rscript/final_head.txt ./Significance_"$p_val"/Top_miRs_best_counts_corrected.txt
cut -f 2- Significance_"$p_val"/Top_miRs_best_counts.txt  >> Significance_"$p_val"/Top_miRs_best_counts_corrected.txt
### Extract statistcs to calculate 
#while read top; do ali=`echo $top | awk '{print $2}' `; lib=`echo $top | awk '{print $1}'`; met=`echo $top | awk '{print $3}'`; mir=`echo $top | awk '{print $5}'`; grep -P "$met\t$mir" ../Final/$lib/$lib"_"$ali"_total.txt"; done < Top_miRs_best_score_uq.txt > Top_miRs_best_counts.txt


for f  in `cat Significance_"$p_val"/miRs_top_all_analysis.txt`
 do 
awk -v mir="$f" -v pval="$p_val" '{if($5 == mir && $10 <=pval){print $0}}' Total_raw_statiscs_Top_only_contrast.txt  |\
awk '{print $5"\t"$1"_"$2"_"$3}' | sort | uniq  |\
awk '{if(a[$1])a[$1]=a[$1]"\n"$2; else a[$1]=$2;}END{for (i in a)print a[i];}'  >Significance_"$p_val"/$f.txt  
 done 

#Rate each mIR 
 for f in `cat Significance_"$p_val"/miRs_top_all_analysis.txt `
 do
 echo -ne "$f\t"
	 for i in $3 
	 do 
	 grep -c $i"_Lib_6" Significance_"$p_val"/$f.txt | awk '{print $0/16}' | tr '\n' '\t' && grep -c $i"_Lib_12" Significance_"$p_val"/$f.txt |\
	 awk '{print $0/16}' |tr '\n' '\t'  && grep -c $i"_Lib_24" Significance_"$p_val"/$f.txt | awk '{print $0/16}' | tr '\n' '\t' 
	 done
 echo
 done > Significance_"$p_val"/TP_rate.txt 

 for f in `cat Significance_"$p_val"/miRs_top_all_analysis.txt `
 do
 echo -ne "$f\t"
	for i in $3 
	do
	grep  $i"_Lib_6" Significance_"$p_val"/$f.txt | cut -d'_' -f 4| sort  | uniq  | wc | awk '{print $1/4}' |\
	tr '\n' '\t' && grep $i"_Lib_12" Significance_"$p_val"/$f.txt | cut -d'_' -f 4 | sort | uniq  | wc |\
	awk '{print $1/4}'|tr '\n' '\t'  && grep $i"_Lib_24" Significance_"$p_val"/$f.txt |  cut -d'_' -f 4 | sort |\
	uniq  | wc | awk '{print $1/4}' | tr '\n' '\t'
	done 
 echo
 done > Significance_"$p_val"/TP_rate_by_aligner.txt 

 for f in `cat Significance_"$p_val"/miRs_top_all_analysis.txt ` 
 do 
 echo -ne "$f\t"
        for i in $3 
        do 
        grep  $i"_Lib_6" Significance_"$p_val"/$f.txt | cut -d'_' -f 5| sort  | uniq  | wc | awk '{print $1/4}' |\
        tr '\n' '\t' && grep $i"_Lib_12" Significance_"$p_val"/$f.txt | cut -d'_' -f 5 | sort | uniq  | wc |\
        awk '{print $1/4}'|tr '\n' '\t'  && grep $i"_Lib_24" Significance_"$p_val"/$f.txt |  cut -d'_' -f 5 | sort |\
        uniq  | wc | awk '{print $1/4}' | tr '\n' '\t' 
        done   
 echo
 done > Significance_"$p_val"/TP_rate_by_norm.txt

 sed -i '1s/^/miR\t5_6\t10_6\t20_6\t30_6\t40_6\t50_6\t5_12\t10_12\t20_12\t30_12\t40_12\t50_12\t5_24\t10_24\t20_24\t30_24\t40_24\t50_24\n/' Significance_"$p_val"/TP_rate.txt
 sed -i '1s/^/miR\t5_6\t10_6\t20_6\t30_6\t40_6\t50_6\t5_12\t10_12\t20_12\t30_12\t40_12\t50_12\t5_24\t10_24\t20_24\t30_24\t40_24\t50_24\n/' Significance_"$p_val"/TP_rate_by_aligner.txt
 sed -i '1s/^/miR\t5_6\t10_6\t20_6\t30_6\t40_6\t50_6\t5_12\t10_12\t20_12\t30_12\t40_12\t50_12\t5_24\t10_24\t20_24\t30_24\t40_24\t50_24\n/' Significance_"$p_val"/TP_rate_by_norm.txt


  awk 'NR>1{m=$2;for(i=2;i<=NF;i++)if($i>m)m=$i;print $1"\t",m}' Significance_"$p_val"/TP_rate.txt > Significance_"$p_val"/TP_rate_best_miRs.txt
  awk 'NR>1{m=$2;for(i=2;i<=NF;i++)if($i>m)m=$i;print $1"\t",m}' Significance_"$p_val"/TP_rate_by_aligner.txt > Significance_"$p_val"/TP_rate_by_aligner_s.txt
  awk 'NR>1{m=$2;for(i=2;i<=NF;i++)if($i>m)m=$i;print $1"\t",m}' Significance_"$p_val"/TP_rate_by_norm.txt > Significance_"$p_val"/TP_rate_by_norm_s.txt
# awk 'NR>1{m=$2;for(i=2;i<=NF;i++)if($i>m)m=$i;print $1"\t",m}' TP_sub_rate.txt  > TP_sub_rate_summary.txt 
#for f in `cat Top_miRs_sub_report.txt`; do echo -ne "$f\t"; for i in 5 10 20 30 40 50; do grep -c $i"_Lib_6" $f.txt | awk '{print $0/16}' | tr '\n' '\t' && grep -c $i"_Lib_12" $f.txt | awk '{print $0/16}' |tr '\n' '\t'  && grep -c $i"_Lib_24" $f.txt | awk '{print $0/16}' | tr '\n' '\t' ;done ;echo; done > TP_sub_rate.txt ; sed -i '1s/^/miR\t5_6\t10_6\t20_6\t30_6\t40_6\t50_6\t5_12\t10_12\t20_12\t30_12\t40_12\t50_12\t5_24\t10_24\t20_24\t30_24\t40_24\t50_24\n/' TP_sub_rate.txt 

