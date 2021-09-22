chr=$1
start=$2
end=$3
file=$4

if [ "$5" = "e" ] 
then
echo testing $chr $start $end $file in $5 mode
awk -v chr="$chr" -v start="$start" -v end="$end" '{if($1 == chr && $2 == start && $3 ==  end) print $0 }' < $file

else
echo testing $chr $start $end $file in overlapping mode  

awk -v chr="$chr" -v start="$start" -v end="$end" '{if($1 == chr && $2 <  end && $3 >  start) print $0 }' < $file
fi 
