#!/bin/bash

name=`basename -s ".bed"  $1 `
sort -k 2n,3n  -o $name $1
	for i in {1..22}; 
	do
#	echo "chr"$i
#	sort -nk 2 $1 > $name.temp
	grep -w "chr"$i $name   >> $name"o.bed"
	done 

	for j in X Y M 
	do 
	grep -w "chr"$j $name  >> $name"o.bed"
	done 
mv $name"o.bed" $name".bed" 
rm $name
echo " the bed file $name".bed" has been sorted by chromosome  " 
cut -f 1 $name".bed"  | uniq
