#!/bin/bash
# bash 
cd "$1"Results/"$2"/Bam/

#744_Control_tmm_RA.sam

parallel --jobs 2 ' name=`basename -s ".mapped.bam" {} `
echo merging the bam files $name 
samtools merge -f $name"_total.bam" "$name".mapped.bam "$name"_RA.mapped.bam
samtools index $name"_total.bam" 
bedtools bamtobed  -i $name"_total.bam" > $name"_total.bed" 
bash /scr/hercules1san/aigutierrez/Total_Preprocessing/bed_cleaning.awk $name"_total.bed" $name "Step1" 
bash /scr/hercules1san/aigutierrez/Total_Preprocessing/order_bed.sh $name.counts.bed >/dev/null
mergeBed -s -scores sum -i $name.counts.bed > $name.counts.temp
bash /scr/hercules1san/aigutierrez/Total_Preprocessing/bed_cleaning.awk $name.counts.temp $name "Step2"
rm $name"_total.bed" $name.counts.bed $name.counts.temp 
bash /scr/hercules1san/aigutierrez/Total_Preprocessing/order_bed.sh $name.merge.bed >/dev/null
echo "Extracting miRs aligned seq from $name" 
cd "'$1'"Results/"'$2'"/Bam/Mirna 
intersectBed  -s -wo -a "'$1'"Results/"'$2'"/Bam/$name.merge.bed -b /scr/hercules1san/aigutierrez/Total_Preprocessing/hg19_hairpin_alldb.bed >$name.miRNA.bed
bash /scr/hercules1san/aigutierrez/Total_Preprocessing/order_bed.sh $name.miRNA.bed >/dev/null 2>/dev/null
samtools view -H   "'$1'"Results/"'$2'"/Bam/$name"_total.bam" > $name.miRNA.sam
samtools view -L $name.miRNA.bed "'$1'"Results/"'$2'"/Bam/$name"_total.bam" >> $name.miRNA.sam
samtools view -bS $name.miRNA.sam >  $name.miRNA.bam  
samtools index $name.miRNA.bam 
rm $name.miRNA.sam
echo "Generating the bam file for ncRNA"
cd "'$1'"Results/"'$2'"/Bam/Ncrna
intersectBed -v  -s -wo -a "'$1'"Results/"'$2'"/Bam/$name.merge.bed  -b /scr/hercules1san/aigutierrez/Total_Preprocessing/hg19_hairpin_alldb.bed > $name.ncRNA.bed
 bash /scr/hercules1san/aigutierrez/Total_Preprocessing/order_bed.sh  $name.ncRNA.bed >/dev/null 2>/dev/null
samtools view -H   "'$1'"Results/"'$2'"/Bam/$name"_total.bam" >  $name.ncRNA.sam
samtools view -L $name.ncRNA.bed "'$1'"Results/"'$2'"/Bam/$name"_total.bam" >> $name.ncRNA.sam
samtools view -bS $name.ncRNA.sam >  $name.ncRNA.bam  
samtools index $name.ncRNA.bam
 rm $name.ncRNA.sam ' ::: *_$3.mapped.bam 
#rm *_$3.mapped.bam
