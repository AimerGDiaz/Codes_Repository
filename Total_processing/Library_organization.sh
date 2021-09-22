cut -f 5,8-10,26 SraRunTable.txt |tail -n +2 > Library_Biological_info.txt
#Run_s	age_s	gender_s	group_s	source_name_s
#SRR837437	77	female	alzheimer patient	whole blood

mkdir Control/ Alzheimer/ 2>/dev/null
 
while read accession
do 
SRRcode=`echo $accession | awk '{print $1}'`
SRRid=`echo $SRRcode | awk -F 'SRR837' '{print $2}'`  
Age=`echo $accession | awk '{print $2}'`
gender=`echo $accession | awk '{print $3}'`
group=`echo $accession | awk '{print $4}' | awk -F' ' '{print $1}' `
#echo $SRRcode $Age $gender $group
	if [ "$group" == "alzheimer" ] 
	then
	cp $SRRcode.fastq.gz Alzheimer/$group"_"$gender"_"$Age"_"$SRRid.fastq.gz 
	else
	cp $SRRcode.fastq.gz Control/$group"_"$gender"_"$Age"_"$SRRid.fastq.gz
	fi
# $SRRcode.fastq.gz 
done < Library_Biological_info.txt


