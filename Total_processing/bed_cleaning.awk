#chr10   327990  328065  744_Control_1821232_1   25      -

if [ "$3" == "Step1" ]
then 
 awk  'OFS="\t"{ header=$4;gsub(/_S_final$|_S_noise$/,"",header) ; count=header; gsub(".*_","",count) ; gsub("_[0-9]*$","",header) ; print $1,$2,$3, header, count, $6  }' $1 > $2.counts.bed
#awk  'OFS="\t"{ header=$4;gsub(/_S_final$|_S_noise$/,"",header) ; count=header; gsub(".*_","",count); gsub("_[0-9]*$","",header) ; print $1,$2,$3, header, count  }'
elif [ "$3" == "Step2" ]
then
awk  -v i="0" -v name="$2" 'OFS="\t"{ if($4 >= 50) {i++;  print $1,$2,$3,name"_merged_"i,$4,$5}}' $1 > $2.merge.bed
fi

