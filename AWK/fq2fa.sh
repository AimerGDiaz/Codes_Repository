name=`echo $1 | awk -F '.fq|.fastq' '{print $1}'`

awk ' BEGIN {OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; print ">"header,seq}' $1 > $name.fa
