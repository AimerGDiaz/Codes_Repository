#!/bin/bash


cd "$1"Specific_Code/
awk -v s=1 '{print ">Adapter_"s"/1\n"$1; s++}'  true_adapters_finded.txt  > true_adapters.fa
blastclust -p F -W 8  -b F -i true_adapters.fa  | grep ^Adapter | cut -d' ' -f 1 > uniq_seqs.txt 
grep --no-group-separator  -f uniq_seqs.txt -w -A 1 true_adapters.fa > true_adapters_r.fa 
#egrep --no-group-separator -w -A 1 "Adapter_1|Adapter_118|Adapter_119|Adapter_120|Adapter_121|Adapter_122|Adapter_123|Adapter_124|Adapter_125|Adapter_126|Adapter_127|Adapter_128|Adapter_129|Adapter_130|Adapter_131|Adapter_132|Adapter_133|Adapter_134|Adapter_135|Adapter_136|Adapter_137|Adapter_138|Adapter_139|Adapter_140|Adapter_141|Adapter_142|Adapter_143|Adapter_144|Adapter_145|Adapter_146|Adapter_147|Adapter_148|Adapter_149|Adapter_150|Adapter_151|Adapter_152|Adapter_153|Adapter_154|Adapter_155|Adapter_156|Adapter_157|Adapter_158|Adapter_159|Adapter_160|Adapter_161|Adapter_162|Adapter_163|Adapter_164|Adapter_165|Adapter_166|Adapter_167|Adapter_168|Adapter_169|Adapter_170|Adapter_171|Adapter_172|Adapter_173" true_adapters.fa  > true_adapters_r.fa
cd "$1"Fastq
for f  in *$2""
do
       	{
	       	name=`basename -s "$2" $f`
		#9 nt 
	       	java  -jar /usr/local/Trimmomatic-0.36/trimmomatic-0.36.jar SE -trimlog $name.log $f $name"_trim.fq" ILLUMINACLIP:"$1"Specific_Code/true_adapters_r.fa:0:100:6 MINLEN:16 2>> $name.log
       	}&
done
wait

#	awk 'OFS="\n"{header = $1; getline seq ; getline qhearder; getline qseq; if (length(seq) > 15 ) print header,seq,"+",qseq}' HBV-cancer-10-TGACCA_trim.fq.reduced.fastq
