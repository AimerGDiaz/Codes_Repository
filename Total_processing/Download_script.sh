#!/bash

#files=( `tr '\t' '_' < SRR_Acc_List.txt | tr '\n' ' '`)
files=( `tr '\t' '_' < SRR_Acc_List2.txt | tr '\n' ' '`)

g=5

for ((i=0; i < ${#files[@]}; i+=g))
do
  part=( "${files[@]:i:g}" )
       for accession in ${part[@]}
        do
	{
	echo "Download $accession"  
	SRXcode=`echo $accession | awk -F '_' '{print $1}'`
	SRRcode=`echo $accession | awk -F '_' '{print $2}'`
	wget ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByExp/sra/SRX/SRX273/$SRXcode/$SRRcode/$SRRcode.sra 2> /dev/null 
        ./sratoolkit.2.8.2-1-centos_linux64/bin/fastq-dump.2.8.2  $SRRcode.sra 
#	rm $SRRcode.sra
	}&
        done
	wait 

#  echo "Elements in this group: ${part[*]}"
done

ls -lh *sra | awk -F' '  '{print $5"\t"$9}' > test_size 
tail -n +2 SraRunTable.txt |cut -f 4,5  > test_size_complement
paste test_size_complement test_size > download_succes_info.log 
rm test_size test_size_complement 

#if there are problems 
	#for f  in `ls  *sra`
	# do 
	# name=`basename -s ".sra" $f`
	# grep $name SRR_Acc_List.txt >> opposite
	# done 
	# sort SRR_Acc_List.txt opposite | uniq -u  > SRR_Acc_List2.txt
	# rm opposite

#for ((i=0; i < ${#files[@]}; i+=g))
#do
#  part=( "${files[@]:i:g}" )
#   time for accession in ${part[@]}
#   do
#   {
#   ./sratoolkit.2.8.2-1-centos_linux64/bin/fastq-dump.2.8.2 --gzip $accession 
#   } & 
#   done 
#   wait 
#done 
 #single download 
#while read accession
#do
#echo "Download $accession" >>Download_time.log
#SRXcode=`echo $accession | awk '{print $1}'`
#SRRcode=`echo $accession | awk '{print $2}'`
#
#time  wget ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByExp/sra/SRX/SRX273/$SRXcode/$SRRcode/$SRRcode.sra 2>> Download_time.log 
#done  < SRR_Acc_List.txt
