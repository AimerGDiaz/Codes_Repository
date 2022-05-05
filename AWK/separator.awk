echo -ne "\nExtracting only the fields 1,2,4 and 8 \n\n"
if [ "$2" == "gsub" ]
then
awk -F',' 'OFS="\t"{gsub("\"","",$0);gsub(" |, ","_",$0);print $1,$2,$4,$8}' $1 
else
awk -F'(,"|",)' 'OFS="\t"{gsub(" ","_",$0); print $1,$2,$4,$8}' $1 | tr -d '"'
fi