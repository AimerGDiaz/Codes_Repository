
1       aa
2       aa
3       bb

echo -ne "1\taa\n2\taa\n3\tbb\n" | awk '{if(a[$2])a[$2]=a[$2]":"$1; else a[$2]=$1;}END{for (i in a)print i,a[i];}'


aa 1:2
bb 3

