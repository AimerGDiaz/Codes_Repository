if [ "$2" == "gsub" ]
then

echo -ne "\nExtracting only the fields 1,2,4 and 8 \n\n"

awk -F',' 'OFS="\t"{gsub("\"","",$0);gsub(" |, ","_",$0);print $1,$2,$4,$8}' $1 
elif [ "$2" == "F" ]
then 

awk -F'(,"|",)' 'OFS="\t"{gsub(" ","_",$0); print $1,$2,$4,$8}' $1 | tr -d '"'

elif [ "$2" == "SRA" ]
then

echo -ne "\nExtracting most informative fields \n\n"

awk -F'(,"|",)' -v OFS="," '{ print $1,$5 }' $1  | awk -F',' -v OFS="," '{gsub(" ","_",$0);gsub("ncRNA-Seq","smallRNA-Seq",$2); print $1,$16,$2,$19,$11,$24,$20,$10,$13,$3,$4,$26}'

elif [ "$2" == "IF" ]
then

awk -F'(,"|",)' -v OFS=","  '{gsub(" ","_",$0); print $1,$5 }' $1  | awk -F',' -v OFS="," '{if (NR == "1") {$10=$11=$12=""; print $1,$19,$2,$22,$14,$27,$23,$13,$16,$3,$4,$29 } else {gsub("ncRNA-Seq","smallRNA-Seq",$2);print  $1,$16,$2,$19,$11,$24,$20,$10,$13,$3,$4,$26}}'

fi