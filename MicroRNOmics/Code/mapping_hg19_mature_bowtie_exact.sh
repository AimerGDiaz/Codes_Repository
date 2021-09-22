cd /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases 
bowtie -n 0 -e 1 -p 16 -l 8 -a --best --strata --phred33-quals --chunkmbs 20000 -S /scr/hercules1san/genomes/Homo_sapiens/hg19/hg19 -f /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases/mature_mix.final.fa > hg19_mature_bowtie.sam 

bowtie -n 0 -e 1 -p 16 -l 8 -a --best --strata --phred33-quals --chunkmbs 20000 -S /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases/hairpin_database -f /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases/mature_mix.final.fa > hairpin_mature_bowtie.sam

for sam in hg19_mature_bowtie.sam hairpin_mature_bowtie.sam 
do 
name=`basename -s ".sam" $sam`
 samtools view -bS $sam | samtools sort - $name
 samtools view -f 4 $name.bam > $name.unmapped.sam
 samtools index  $name.bam $name.bai 
bedtools bamtobed -i  $name.bam > $name.bed
rm $sam $name.bam $name.bai 
done 
