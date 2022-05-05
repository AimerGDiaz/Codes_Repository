echo -ne "\nExtracting only the fields 1,2,4 and 8 \n\n"
#awk -F'[,"|",]' 'OFS="\t"{gsub("\"","",$0);gsub(" ","_",$0);print $1,$2,$4,$8}'  $1
if [ "$2" == "gsub" ]
then
echo $2
awk -F',' 'OFS="\t"{gsub("\"","",$0);gsub(" |, ","_",$0);print $1,$2,$4,$8}' $1 
else
echo no
fi
