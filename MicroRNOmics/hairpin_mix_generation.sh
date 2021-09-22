#!/bin/bash

 for hairpins in /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Hsa_analysis/hairpin_v2*.fa
 do 
 name=`basename -s ".fa" $hairpins `
 awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' $hairpins \
 > /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases/$name.ol.fa
 done


 for mir  in `grep -v ">" /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases/hairpin_v20_hsa.ol.fa ` 
 do
 if ! grep -q $mir /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases/hairpin_v21_hsa.ol.fa
	 then 
	 grep --no-group-separator -wB 1 $mir /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases/hairpin_v20_hsa.ol.fa 
	 fi
 done > /scr/hercules1san/aigutierrez/MicroRNOmics/Data/Mix_databases/hairpin_v20_uniq.hsa.ol.fa


##diferences in length between v20 and  v 21 

 for f  in `cut -f 1,3 length_hairpin_v20_hsa.txt length_hairpin_v21_hsa.txt  | sort | uniq -u | cut -f 1 | sort | uniq -d  `; do grep -w $f length_hairpin_v20_hsa.txt length_hairpin_v21_hsa.txt; done 

#######3
 
#5`.2 Name change to avoid problems and merge
#
#while read L ; do  if [[ $L == ">"* ]]; then cor=`echo "$L" | cut -d' ' -f 1`; echo $cor"-V20" >> a.fa; else echo $L  >> a.fa; fi; done < hairpin_v20_uniq.hsa.ol.fa ; mv a.fa hairpin_v20_uniq.hsa.ol.fa
#
#5`.3 Test new data set
#
#for f  in `grep -v ">" ../hairpin_v20.hsa.ol.fa ` ; do if ! grep -q $f ../hairpin_v21.hsa.ol.fa ; then grep -wB 1 $f hairpin_v20_uniq.hsa.ol.fa; fi; done
#
#5`.4 Merge no-hsa with hairpin.mix
#
#cat ../hairpin_v21.hsa.ol.fa hairpin_v20_uniq.hsa.ol.fa > hairpin_mix.hsa.ol.fa
#
#for f  in `grep -v ">" ../hairpin_v20.hsa.ol.fa ` ; do if ! grep -q $f hairpin_mix.hsa.ol.fa;  then grep -wB 1 $f hairpin_v20_uniq.hsa.ol.fa; fi; done
#
#cat ../../Hairpin_to_hg19/Non_hsa/hairpin_mix_unannotated.fa  hairpin_mix.hsa.ol.fa > hairpin_mix_total.fa
#
#for f  in `grep -v ">" ../../Hairpin_to_hg19/Non_hsa/hairpin_mix_unannotated.fa ` ; do if ! grep -q $f  hairpin_v21.hsa.ol.fa ; then grep -wB 1 $f ../hairpin_v20.hsa.ol.fa; fi; done
#
#5`.5 Test againts total bed 
#
#for f in `grep ">" hairpin_mix_total.fa | cut -d' ' -f 1 | tr -d '>'`; do if ! grep -wq $f ../../Hairpin_to_hg19/hg19_hairpin_mix.total.bed  ; then  cor=`echo $f | cut -d'-' -f 2- `; if ! grep -w  $cor ../../Hairpin_to_hg19/hg19_hairpin_mix.total.bed; then echo $f; fi;  fi ; done 
#
#5`.6 Transfer to hercules and change U > T
#
#while read L ; do  if [[ $L == ">"* ]]; then echo "$L" | cut -d' ' -f 1  >> a.fa; else echo $L | tr "AUGCaugc" "ATGCatgc" >> a.fa; fi; done < hairpin_mix_total.fa  ; mv a.fa  hairpin_mix_total.fa
#
#5`.6 Align against hg19
#
#qsub -cwd -q normal.q@hercules5 mapping_hg19_hairpin.sh
#
#5`.7 Compare against blast_out.bed 

