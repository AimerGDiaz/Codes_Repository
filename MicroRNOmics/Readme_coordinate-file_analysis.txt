1 - Download either mirBase gff files or Seq
#from gff3 to bed

gff3_2bed.pl [hsa_total_v20.gff3|hsa_total_v21.gff3] 

--Output--
hsa_total_v20_mature_miRNA.bed
hsa_total_v20_pre_miRNA.bed
hsa_total_v20_total.bed

The code gff32bed_short.pl generate a bed file preserving the headers 

1.1 - check

for f in `tail -n 4695 hsa_total_v21.gff3 | cut -f 4 ` ; do if ! grep -w $f hsa_total_v21_total.bed ; then echo $f; fi;  done
for f in `cut -f 2 hsa_total_v21_mature_miRNA.bed ` ; do if ! grep -qw $f hsa_total_v21.gff3 ; then echo $f; fi;  done

2 - Filter non hsa entries

perl read_fasta_headers.pl hairpin_v20.fa hsa

3 - Add _ to recover mirBase ID

for f in  *v2[0-1].hsa.fa; do name=`echo $f | cut -d'.' -f 1`; tr ' ' '_' < $f > "$name"_c.fa ;done

4 - Extract the length of each miR

for f in  *_c.fa; do perl ../../Code/lengh_seq.pl $f; done

5 - 
